Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXFBTuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXFBTuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbXFBTu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:50:27 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:36009
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760359AbXFBTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:50:26 -0400
Date: Sat, 2 Jun 2007 12:51:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <6419.1180811687@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0706021235590.954@asgard.lang.hm>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com>
 <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz>
 <12508.1180719875@turing-police.cc.vt.edu> <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
 <14604.1180770021@turing-police.cc.vt.edu>           
 <Pine.LNX.4.64.0706020723030.954@asgard.lang.hm> <6419.1180811687@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Valdis.Kletnieks@vt.edu wrote:

> On Sat, 02 Jun 2007 07:27:13 PDT, david@lang.hm said:
>
>>> The type of hardening that AppArmor can provide network-facing daemons is only
>>> protecting the system against attacks that aren't even a large part of the
>>> threat model.   Exploiting a broken PHP script? Happens all the time, and
>>> AppArmor can't do much for it.
>>
>> actually, this is _exactly_ where AppArmor is the most useful. if the PHP
>> script is restricted by AppArmor it won't be able to go out and touch
>> things that it's not supposed to.
>
> OK. I'll bite.  AppArmor basically only mediates filename objects.

for now, the AppArmor folks have said that the next step is to move on to 
other objects (like network connections) after the initial step is 
accepted.

> What filename do you specify to stop it when the exploited PHP script is used
> bu a spammer to send mail to millions, when it was intended to send mail only
> to a specific set of people?  Wait, that's a tcp connection to localhost:25.
>
> What filename do you specifu to stop blog comment spam and other abuses of a
> content management system (remember that the PHP code *does* need write access
> to the files in question)?

it stops the PHP script from spawning a shell that would be considered a 
'local trusted user'

if you use SELinux and give the PHP script permission to write to your 
content management system then the PHP script can corrupt that system if 
it's exploited. AppArmor is the same way

this is Security 101 (or even more basic), if you grant a program access 
to do something you can't prevent that program from doing that something.

> It might be able to stop J Random SkriptKiddy from scribbling "Y0uz Ben Pwned"
> all over your home page, but it doesn't do much to control lots of other abuses
> of web apps.  To be fair, SELinux can't help a lot more, because the problem
> often ends up being abuse of an access privilege that the program *should*
> have - for example, if it's supposed to query the database, it's hard to stop it from making
> an inappropriate query at the level that AppArmor and SELinux work at.

it's not hard, it's impossible

how can you know if the command 'foo' sent to another program on your 
system will cause that system to erase everything it has access to or 
return 'bar'? you don't and no system tool can (and no system tool should)

if you want to control what commands one program can send to another you 
need a security proxy between them. that isn't what AppArmor or SELinux 
are trying to do so don't blame them for not doing it.

> I'm not convinced that it's solving enough *actual* problems, given that we've
> rejected a lot of other "helps a little in some cases" code for kernel
> inclusion.

you seem to want a 'only let the system do what the programmer intended' 
command, and anything less isn't solving the actual problem. by that logic 
we shouldn't bother with passwords either, since they don't completely 
solve the problem

>> if you are targeting one specific company or one specific server then you
>> are correct,
>
> There's a lot of that going around.  And they're the attacks that you need to
> worry about, because you're likely to end up as a headline.
>
>>              however most attacks are not that targeted,
>
> There's a big difference between "most attacks" and "most attacks you should
> worry about".

you first want to knock off all the things in that 'most attacks' catagory 
so that you can pay close attention to the threats that are targeted 
directly at you.

>>                                                          they do things
>> like useing google to find random servers that are running vunerable
>> software and attack that
>
> Rmember that at a minimum, that also means that you're Goggleable as vulnerable
> to attacks that AppArmor can't stop.  And yes, Googling for vulnerable software
> *is* one of the primary ways that blog spammers find the vulerable blogs.
>
> If your site is run in such a way that you you have to worry about random
> attackers who use google, your site has *bigger* security issues, and thinking
> that AppArmor is going to improve things is exactly the sort of smoke screen
> magic bullet that we don't want putting in the kernel.

when the next exploit is found is network accessable server X, AppArmor 
can prevent it from doing anything to the system that server X wasn't 
already allowed to touch.

For example, this means that it probably won't be allowed to run bash and 
provide a shell to the outside attacker.

It also means that locally exploitable bugs are less likely to be able to 
be combined with remotely exploitable bugs into complete machine takeovers 
becouse the remotely exploitable server would have to have permission to 
access the locally exploitable software.

if you can't see any advantage to this then you would be happy doing a 
chmod -R 777 / on your system (becouse normal user permissions are a much 
more restricted way of limiting the same type of access)

David Lang
