Return-Path: <linux-kernel-owner+w=401wt.eu-S966113AbXDCARK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966113AbXDCARK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966123AbXDCARK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:17:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:54471 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966113AbXDCARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tp7mwmM/CNGu5GaJW1CGjr/rT9KGKLKYbLRwPpnBI83ppew5rc/qdX8auq56sbrQqJOJm2CQxnEf8u2lSj4jDg3fzU8DcAZ5zern87QqQgxsojWu16+Fx4COTRDuaqs4M5QOF/VJA1635b02TLO8d6/gAlMGvk9C2uT6BKGJuE4=
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
In-Reply-To: <46113ED6.4060005@zytor.com>
References: <46110F88.5040905@gmail.com>  <46113ED6.4060005@zytor.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 08:16:17 +0800
Message-Id: <1175559377.7267.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 10:35 -0700, H. Peter Anvin wrote:
> Antonino A. Daplas wrote:
> > Resetting the console, either by ANSI escape sequences or by the reset utility,
> > will drop the console back to legacy (non-UTF-8) mode. Fix this by leaving the
> > field vc_data.vc_utf untouched in reset_terminal(). In addition, a global
> > variable (default_utf8) which defines system-wide UTF-8 setting is created.
> > This variable can be adjusted via sysfs.
> 
> If you're going to introduce a system-wide default, instead of issuing 
> the appropriate escape code, then I would argue it should still be 
> forced (to the default) when issuing a console reset.
> 

That would be the cleanest and purest behavior. But it's possible to set
one console to UTF-8 and another to legacy mode. So one can corrupt the
user's console just by issuing a reset or echo -e '\033c'. (Although one
can argue that users who know what UTF-8 is also knows how to set the
encoding back)

Until userspace is more capable of setting back the terminal to its
previous configuration, I would tend to agree with Jan, that we should
leave the current utf setting of that particular vc alone.

Tony


