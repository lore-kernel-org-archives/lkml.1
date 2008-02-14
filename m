Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbYBNG1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbYBNG1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYBNG1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:27:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:64759 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYBNG1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=ZKfS1ccOnbpP6sSpyyFA2xnXTq7yVg68LuPwYhRnLZhE37RN7WWL7JBoeGdxQNBXpmR2lYSeZQLOpW2om2Bw32XWwmnHRtDKWgTu6wStTwXlZuW5gfdPeVnDuPW6D7RkWRBtJ9zKYIWtMh2/9gbpNkZCk/QQry9ZTXOphIaGOAs=
Date: Thu, 14 Feb 2008 07:26:52 +0100
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       bzolnier@gmail.com
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Message-ID: <20080214062652.GE13446@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Hans-Peter Jansen <hpj@urpla.net>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	bzolnier@gmail.com
References: <200802121026.17420.hpj@urpla.net> <20080212172057.GA12480@gollum.tnic> <200802140037.51450.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802140037.51450.hpj@urpla.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:37:50AM +0100, Hans-Peter Jansen wrote:

[Added Bart to CC]

> Am Dienstag, 12. Februar 2008 schrieb Borislav Petkov:
> > On Tue, Feb 12, 2008 at 10:26:17AM +0100, Hans-Peter Jansen wrote:
> > > Hi,
> > >
> > > I suffer from unreliable cdrom operations (failing DAE and burn
> > > sessions) with the openSUSE 2.6.18.8-0.7-bigsmp kernel.
> >
> > 			^^^^
> > Hi,
> >
> > can please you test this with a more recent kernel. Yours is almost
> > ancient - from Sep. 2006.
> 
> Sure, sorry. Here we go:
> 
> Feb 14 00:18:18 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
>  Trying to recover by ending request.
> Feb 14 00:27:27 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01). 
>  Trying to recover by ending request.
> 
> ~> uname -a
> Linux xrated 2.6.24.1-35-pae #1 SMP 2008/02/12 01:00:18 UTC i686 athlon i386 GNU/Linux

Actually the interrupt handler in ide-cd got rewritten and you're still using the
old one (cdrom_pc_intr vs cdrom_newpc_intr). Those changes went into mainline before
the 2.6.25-rc1 so we'll be able to test the new one only when you try out 2.6.25-rc1
or wait until 2.6.25 is released in case you don't want to try hazardous materials
such as an -rc kernel[*] :).

Bart?

*. As a matter of fact it runs quite smoothly on my machines.

-- 
Regards/Gruﬂ,
    Boris.
