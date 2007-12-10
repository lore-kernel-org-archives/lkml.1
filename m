Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbXLJEyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbXLJEyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXLJEwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:52:24 -0500
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:48564 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755039AbXLJEwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:52:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=4pvdEgEksEuucJbXeZ6StoYROj00+dVA319f6qDYe/w5p3mtyKWimxUr/AEJbxlSDngRm+l308605KhEaDu082MElvz0Uo3ar86Ul7uFbvqvxobXU5iq6LFW/DS2mT+9Y4PTx5U+anjs2RaamoIdxzUqF0FPE+NfW2cWWGVy44k=  ;
X-YMail-OSG: Etgx338VM1lQYk4n7h4Q32fKRZmaUkNQ3zhBbL0PT._oeGZ5aqe0ZJC7jmIpYQBHZdc4ADYQAA--
Date: Mon, 10 Dec 2007 05:51:04 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] swap image signature check upon resume
Message-ID: <20071210045104.GA7169@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <200712091527.57523.rjw@sisk.pl> <20071209160959.GA4978@gollum.tnic> <200712092246.36217.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712092246.36217.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 10:46:35PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 9 of December 2007, Borislav Petkov wrote:
> > On Sun, Dec 09, 2007 at 03:27:57PM +0100, Rafael J. Wysocki wrote:
> > ...
> > 
> > > > Instead, I'd rather issue a warning that the swsusp header mismatches, say with
> > > > which kernel the machine got suspended with and then start the countdown for reboot.
> > > 
> > > What exactly would that change?  You need to reboot anyway and fsck will run on
> > > the filesystems regardless of which kernel you boot with.
> > 
> > well, you'll have the chance to reboot with the kernel the machine got suspended
> > with and then the swsusp image header _will_ match so no fsck-ing. or am i
> > missing something...
> 
> Yes, you are. :-)
> 
> With the new code (which BTW I'm assuming we are talking about) the images are
> not matched against the kernel they were created by, but against a hard-coded
> magic number (defined in suspend_64.c) playing the role of the "header protocol
> version" and against some system parameters, like the amount of RAM etc.
> Since all kernels containing the new code use the same magic number, all of
> them will match or none of them will match.

right, i was kinda wondering when actually a swsusp image won't match after looking
at check_image_kernel() but missed that arch-specific RESTORE_MAGIC bit.
Thanks for clearing that up.

-- 
Regards/Gruﬂ,
    Boris.
