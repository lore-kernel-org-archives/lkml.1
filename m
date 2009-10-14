Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZJNE7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZJNE7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZJNE7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:59:34 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:62974 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZJNE7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h/XOxJ4Qy2q3laiOKBkcjiLqv9SSwdRg8hiKeEpN+NByVrlUp7WR/rjdI9/zeSVqQ/
         Sslmr7tZFfpeCWKvP+Dt2rsYI8UqXuoHQccpW1jxMlOkdeZRTRxsyhJ8kkmu8KapbyA8
         TCguWcoqqAsGLSBRvXkoAd5Yk5NuWWyzkTMUo=
Date: Tue, 13 Oct 2009 21:58:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20091014045851.GA32413@core.coreip.homeip.net>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ressurecting old thread...]

On Wed, Jul 08, 2009 at 01:20:23PM +0200, Jiri Kosina wrote:
> On Tue, 7 Jul 2009, Dmitry Torokhov wrote:
> 
> > > > One new issue I see in 2.6.30 (I think I saw it in some rc*s) too is 
> > > > that console switch often leaks the Fkey of the console switch into the 
> > > > target console.
> > > > 
> > > > The symptome is that e.g. firefox if it was active and you're switching
> > > > into X displays its help screen (F1 = help). It happens on non X 
> > > > consoles too, but of course the symptoms are different here.
> > > > 
> > > > That's a regression against 2.6.29; I don't remember it in .29
> > > > 
> > > > Haven't investigated code.
> > > 
> > > Are you seeing with a specific keyboard type(s), or is this a general 
> > > problem? Could you confirm whether it is specific either 
> > > to PS2 or USB keyboards only, or it does happen for both?
> > 
> > Can't think of any input chnages in this timeftrame that would cause
> > such effect. Maybe TTY changes?
> 
> For completness, Andi sent me the following evtest output off-list 
> yesterday. The LeftAlt being autorepeated at time 1246964430.448470 is a 
> little bit suspicious, as it is preceeded by release ... I don't see how 
> this could be causing the behavior Andi is observing though.
> 
> I am not able to reproduce the problem myself.
> 

...

> Event: time 1246964431.804460, -------------- Report Sync ------------
> Event: time 1246964431.828598, type 4 (Misc), code 4 (ScanCode), value 70040
> Event: time 1246964431.828602, type 1 (Key), code 65 (F7), value 1
> Event: time 1246964431.828604, -------------- Report Sync ------------
> Event: time 1246964431.832468, type 17 (LED), code 0 (NumLock), value 0
> Event: time 1246964431.832470, -------------- Report Sync ------------
> Event: time 1246964431.988595, type 4 (Misc), code 4 (ScanCode), value 700e0
> Event: time 1246964431.988601, type 1 (Key), code 29 (LeftControl), value 0
> Event: time 1246964431.988603, type 4 (Misc), code 4 (ScanCode), value 700e2
> Event: time 1246964431.988605, type 1 (Key), code 56 (LeftAlt), value 0
> Event: time 1246964431.988608, type 4 (Misc), code 4 (ScanCode), value 70040
> Event: time 1246964431.988610, type 1 (Key), code 65 (F7), value 0
> Event: time 1246964431.988611, -------------- Report Sync ------------

Btw, what kind of keyboard is this? I was playing today but I could not
get my USB keyboards to report release of more than 1 key per report....

-- 
Dmitry
