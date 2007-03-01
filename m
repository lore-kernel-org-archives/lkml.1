Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXCAByq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXCAByq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbXCAByq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:54:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:12151 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbXCAByp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aDtM8V3jV3Ng0c4NUn0QpoccPjN+OBiJ615SPMpCxvEaASENDtd2syh5HniF3mU8AfJ/WudstpUY/ljqAEBfBnD9UBmzswZvMwQMkoGZCHPLpwQLvvWCIynDc05xJ+QEDsGs/fXhVNNIliM35/aIAQFxlcpVaw7RsxiIiNW4dvw=
Subject: Re: [PATCH]: Fix radeon blanking return value.
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070228.162016.74750990.davem@davemloft.net>
References: <20070228.162016.74750990.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 09:56:50 +0800
Message-Id: <1172714210.21204.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 16:20 -0800, David Miller wrote:
> If you'll recall, over a year ago, I pointed out that the current
> Radeon driver erroneously returns -EINVAL for valid blanking codes,
> here is a link to that thread:
> 
> 	http://lkml.org/lkml/2006/1/28/6
> 
> No other driver does this, and it confuses the X server into thinking
> that the device does not support blanking properly.
> 
> As a result I have to switch to a console VC and back to the X server
> to unblank the screen, which is rediculious.
> 
> I've had to do this for more than 3 years and I'm really tired of this
> problem still being around :-)
> 
> I looked again and there is simply no reason for the Radeon driver to
> return -EINVAL for FB_BLANK_NORMAL.  It claims it wants to do this in
> order to convince fbcon to blank in software, right here:
> 
> 			if (fb_blank(info, blank))
> 				fbcon_generic_blank(vc, info, blank);
> 
> to software blank the screen.  But it only causes that to happen
> in the FB_BLANK_NORMAL case.
> 
> That makes no sense because the Radeon code does this:
> 
> 		val |= CRTC_DISPLAY_DIS;
> 
> in the FB_BLANK_NORMAL case so should be blanking the hardware, and
> there is therefore no reason to SW blank by returning -EINVAL.
> 
> Therefore I propose we finally apply the following patch.  No other
> fbdev driver does this madness, and as I've shown above there is no
> justification for the behavior at all :-)

This was before radeonfb did not fully differentiate each blanking
levels.  Currently, it is fixed, so I agree with this patch.

> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony


