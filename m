Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYLPQAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYLPQAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbYLPQAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:00:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:14131 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbYLPQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IOHYHd9LWs4I4qNq8N+u5zYuuYuIfdxXvYpJUbHx3+cTgi2JHr33AO9/mG05ETQWxl
         aK/+wDxgzv0uD05XpyDz51Vtprkq8vud0/uiDbd+rZcuxbcHGcEkUh75MNPa3EMiivh1
         dYfUf4Vqkg1bAIdf9wPTIg0xUrk2VtIbPAZxU=
Message-ID: <e2e108260812160800h66e525f2p8c6c78b1b73630d1@mail.gmail.com>
Date: Tue, 16 Dec 2008 17:00:07 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user space data
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
In-Reply-To: <20081210214500.GA24212@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net>
	 <20081210214500.GA24212@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 10:45 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Another approach is to increase skb's shared data (at the end of the
> skb->data), and this approach was not frowned upon too much either, but
> it requires to mess with skb->destructor, which may not be appropriate
> in some cases. If iscsi does not use sockets (it does iirc), things are
> much simpler.

Hello Evgeniy,

Any idea whether it would be acceptable to extend "struct sock" with
one or two pointers to callback functions ? These callback functions
could be called from skb_release_data() etc. through the "struct sock*
sk" member of "struct sk_buff".

Bart.
