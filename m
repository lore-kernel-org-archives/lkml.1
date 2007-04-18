Return-Path: <linux-kernel-owner+w=401wt.eu-S2992639AbXDROfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992639AbXDROfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992634AbXDROfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:35:06 -0400
Received: from cs.columbia.edu ([128.59.16.20]:54275 "EHLO cs.columbia.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992621AbXDROfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:35:04 -0400
Message-ID: <46262C45.7000301@cs.columbia.edu>
Date: Wed, 18 Apr 2007 10:33:41 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
References: <20070417181016.GA10903@one.firstfloor.org> <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org> <20070417225815.000b0fdb@the-village.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei>
In-Reply-To: <Line.LNX.4.64.0704180935100.25495@d.namei>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, X-Seen-By filter1.cs.columbia.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Tue, 17 Apr 2007, Alan Cox wrote:
> 
>> I'm not sure if AppArmor can be made good security for the general case,
>> but it is a model that works in the limited http environment
>> (eg .htaccess) and is something people can play with and hack on and may
>> be possible to configure to be very secure.
> 
> Perhaps -- until your httpd is compromised via a buffer overflow or 
> simply misbehaves due to a software or configuration flaw, then the 
> assumptions being made about its use of pathnames and their security 
> properties are out the window.
> 
> Without security labeling of the objects being accessed, you can't protect 
> against software flaws, which has been a pretty fundamental and widely 
> understood requirement in general computing for at least a decade.

And that's why apparmor should be implemented as a stackable file system 
with a container mechanism, and I implemented such a thing back in 2003, 
albiet mostly just proof of concept and a horribly written paper (it was 
my first), so never got published beyond a tech report.

http://www.ncl.cs.columbia.edu/publications/cucs-005-04.pdf

Basically, on disk labeling is not necessarily an easy mechanism for app 
armor type things as it's not easy to use and different applications 
have different requirements so end up w/ multiple labels attached that 
are difficult to understand.  That's why app armor's path based rules 
are nice, each app has its own set of rules, and one can easily eyeball 
what rules apply to each app, as well as easily change it.  However, 
since apparmor has no conception of the actual file system, so it's 
broken by design.

If on the other hand it was implemented as a stackable file system, each 
fs object would be labeled.  The same underlying FS could be used by 
multiple distinct applications w/ distinct security issues, and one 
could even combine it with something like unionfs to give each domain a 
separate writable area, avoiding the "output file issue", where output 
filess could be used to attack the system.
