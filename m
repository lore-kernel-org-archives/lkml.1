Return-Path: <linux-kernel-owner+w=401wt.eu-S939120AbXGSPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939120AbXGSPS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933439AbXGSPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:17:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7559 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXGSPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LoAJqCYsaoVFAgGNCYqsd5W3r6UexkrVQSiw7EBNajpJrTdTDz53W9pa+ga50VNqYAOD/2fp/4YYK7eZSbkagIRPKgt1u8fha0BPiYw73OlQxIxLyrH4fTuJ4+SDu8cUfIugYpz7ZIFl71geJg4PlkEN/jPuR8+8qRzm1F6+zM8=
Message-ID: <d120d5000707190817t62013ddcg966bd4e8c0ec116f@mail.gmail.com>
Date: Thu, 19 Jul 2007 11:17:50 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Daniel Mantione" <daniel.mantione@freepascal.org>
Subject: Re: Keyboard programming needs root
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <f79qnt$rn3$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f79qnt$rn3$1@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 7/14/07, Daniel Mantione <daniel.mantione@freepascal.org> wrote:
> Hello,
>
> A while back a patch was merged to make that only root can program the
> keyboard:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0b360adbdb54d5b98b78d57ba0916bc4b8871968
>
> Is this patch discussable? I think this patch isn't proper because of the
> following reasons:
>
> * Users can play games in many ways. They can configure the terminal
>  settings, (remove the automatic line feed, disable the echo etc). They can
>  load console fonts. They can still put the keyboard in raw mode, etc.

Keyboard raw mode or disabling line echo may be annoying but you
really don't want someone leaving box after binding "rm -rf /" to a
backspace key...

> * All of these games can be prevented by making mingetty (or whatever getty
>  is used) or PAM can put the console into a known state after logout.
> * All of these games are annoyances, system security is not compromised.
> * I do not see a problem with for example a French user doing a "loadkeys
>  fr" if that allows hims to use the computer easier.
>
> Worst issue for me though, is that KDSBENT is needed to be able to catch
> keys like shift+tab, alt+fx, escape without delay. My application suddenly
> needs root permissions to work properly.

Yes, if your application mucks with the console it has to be trusted...

> The alternative, semi raw mode,
> has the disadvantage that you need to implement your own keymaps (like X).
> In short, this change breaks applications.
>

You may also try reading data directly from evdev devices... They are
normally privileged as well but usually user logged on console is
given access to them.

-- 
Dmitry
