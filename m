Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbXJPOeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbXJPOeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXJPOea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:34:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:25993 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbXJPOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MiXAVkVsKfJlpirOEljvTGpfiDdIXjk+vjkXoFQmggPQVvzq/cDB9AAzv+L2Zhaf/dysMnMPFC3QYfaCtA6Aax2nP/cTDxmCO9Z2ocmEBd70UpSD83NDaCUkQvRvxaacOLTgIPXaFSXvW0F+CpCtmnFEYpsiS5pDTtLvS2w9KTg=
Message-ID: <d120d5000710160734occe82cke989baf3d1f97130@mail.gmail.com>
Date: Tue, 16 Oct 2007 10:34:26 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Kristoffer Ericson" <kristoffer.ericson@gmail.com>
Subject: Re: Power button policy and mechanism
Cc: linux-input <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>,
       "Richard Purdie" <rpurdie@rpsys.net>
In-Reply-To: <20071016134050.f7106efe.Kristoffer.Ericson@Gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016134050.f7106efe.Kristoffer.Ericson@Gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristoffer,

On 10/16/07, Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> Greetings Dmitry,
>
> Is the suggested approach on handling powerbutton (in keyboard driver) to simply push out the event and let userland handle it?

Yes.

> The reason Im asking this is because as you might know Im maintainer for two mini-laptop style pda's (HP7xx & HP6xx)
> and it would simplify my life alot if I didn't need to depend on userland applications to be able to suspend/resume.
>
> For instance HP6XX receives an interrupt call whenever the powerbutton is pressed. Now I could just push out the event and let another program handle it but considering it would take a minimum amount of lines to let it simply suspend/resume I feel its a waste.
>
> Previously the hp6xx has been allowed to do this "policy" way but that was when LinuxSH stod as a side branch to main tree. Now
> when everything gets merged into mainline I need to decide how to do this.
>
> This is mainly an embedded issue, but I feel it's quite important. It should apply to other devices also like for example Zaurus branches (those with keyboard and designated power button).
>
> So in short:
> 1. Does mainline policy allow static power button events inside kernel (power button == suspend/resume)?
>        Why/Why Not?

Could it be that you may want to prevent suspend from happening? Or
delay it until system completes some important operation? Do something
else, like cleanly disconnect your network connections? With actual
handling done in userspace it's all possible. With suspend done
directly in kernel it is much harder and couples input subsystem with
power management too tightly.

However if you are dead-set on doin it in kernel you coudl register an
input_handler in your platform PM code and it will attach to your
keyboard. Look for power.c module in older kernels for example.

> 2. Seeing as my knowledge about this area isn't the best I would appreciate all opinions on the subject from the gurus.
>

Richard Purdie I think might have some pointers.

-- 
Dmitry
