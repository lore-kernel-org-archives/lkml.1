Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZC2O0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZC2O0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZC2O0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:26:00 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:33653 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501AbZC2OZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:25:59 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net 8359339A728
Date: Sun, 29 Mar 2009 16:25:54 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Bodo Eggert <7eggert@gmx.de>, James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: TOMOYO in linux-next
In-Reply-To: <20090329115830.GA15492@elf.ucw.cz>
Message-ID: <alpine.LNX.1.10.0903291613360.20606@be10.lrz>
References: <ck5CF-5mU-11@gated-at.bofh.it> <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org> <20090327114224.GF2585@elf.ucw.cz> <alpine.LSU.0.999.0903271354290.5610@be1.lrz> <20090329115830.GA15492@elf.ucw.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, Pavel Machek wrote:
> On Fri 2009-03-27 14:04:32, Bodo Eggert wrote:
>> On Fri, 27 Mar 2009, Pavel Machek wrote:
>>> On Fri 2009-03-27 10:28:07, Bodo Eggert wrote:
>>>> Pavel Machek <pavel@ucw.cz> wrote:

>>>>> I don't think merging that is good idea. Security should be doable
>>>>> without making shell-like glob matching...
>>>>
>>>> How do you suppose a security system should handle mozilla modifying
>>>> ~/.bashrc differently from downloading something to ~/pr0n.jpg?
>>>
>>> How does shell-like glob matching help there? You'd need to parse
>>> /etc/passwd to find all ~ directories...
>>
>> That is, if you'd use HOME=`dd if=/dev/urandom ...`.
>>
>> If you have your users in /home/user, you can tell /home/*/.*
>> is bad, /home/*/[^.]* is OK.
>
> On the common systems I know of, homes are spread over different
> volumes and different directories. TOMOYO's wildcards do _not_ solve
> this particular problems.

Don't do that then. If you start having user's homes at 
/usr/local/sbin/something/, your systenm is FUBAR anyway.

Put your homes into /home/volume/group/user (=~ /home/*/*/*/.*).

>> How would you exclude mozilla from writing to .* then? ".a" is bad,
>> ".b" is bad ...? or "A" is OK, "a" is OK, "zzzzzzzzzzzzz" is OK"?
>> Either way, you'd need several universes to store the security profile.
>
> What is magic about .* files? I want mozilla to store the pictures as
> .naughty.picture.jpg -- I don't see anything wrong with that.

As long as you have a guaranteed-to-be-complete list of config files, you 
can get along without wildcards. And still if you do, I'll write a program 
to make it incomplete.
