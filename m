Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYEWPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYEWPZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYEWPZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:25:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYEWPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:25:23 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built
	into	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>
In-Reply-To: <s5h4p8pujy3.wl%tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
	 <1211554711.28967.25.camel@pmac.infradead.org>
	 <s5h4p8pujy3.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 16:25:20 +0100
Message-Id: <1211556320.28967.35.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 17:19 +0200, Takashi Iwai wrote:
> Hm, but request_firmware() returns the const pointer.  It implies that
> the caller shouldn't change the content, doesn't it?
> 
> I cannot guarantee that there must be no misbehaving drivers,
> though...

The 'struct firmware' is const. It contains a pointer to data.
That data is not const.

 fw->data = some_other_data; 	// bad.
 fw->data[0] = 0;		// ok.

Of course, we could _make_ it const (if we can remember whether it's
'const u8 *' or 'u8 const *'...)

-- 
dwmw2

