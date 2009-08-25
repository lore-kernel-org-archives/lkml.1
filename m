Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZHYFwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZHYFwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 01:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZHYFwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 01:52:20 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34217 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZHYFwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 01:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=csdnfyx0+uBdaZlo8AG+aFuLk5eOThPcXbz4g0q3/evzoJeNi+A2X7ftkPL/ksAtt/
         5j7U5VBIZcBGR500aUBWwD1X82TJMIjOQ58cEfxeyFDr5gF7qHpyw0InpAH25KrSSlW4
         /rCa7OOGDBc4rp+PcjMGYK2U+ugyCIQzEb3do=
Date: Tue, 25 Aug 2009 07:52:15 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set
 X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <20090825055215.GA22595@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	mingo@redhat.com, linux-kernel@vger.kernel.org,
	kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
 <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org>
 <20090816064132.GA16278@elte.hu>
 <20090816214934.GB7765@liondog.tnic>
 <4A8EDC02.8000508@zytor.com>
 <20090822163750.GA31631@liondog.tnic>
 <4A92F93F.8000502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A92F93F.8000502@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 01:34:07PM -0700, H. Peter Anvin wrote:
> Looks reasonable... although part of me wonders if having a pointer to
> an array containing the entire register file in and out is even better,
> of if I'm just overengineering at this point.

Hmm, let's have necessity determine that. I can only think of %edi being
used as an input reg to rd/wrmsr beside %ecx but it could be very well
that some other x86 hardware uses other regs too. Do we actually need
all regs or a two should suffice?

> Note that the only difference between "rdmsr" and "wrmsr" is the actual
> opcode being executed at this point...

... which means even less code with macro magic.
 
-- 
Regards/Gruss,
    Boris.
