Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbXKDAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbXKDAOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 20:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXKDAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 20:14:10 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39344
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbXKDAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 20:14:09 -0400
Date: Sat, 3 Nov 2007 17:21:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
In-Reply-To: <20071103165525.2dcd55c7@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0711031714130.4780@asgard.lang.hm>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
 <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
 <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
 <20071102010419.23f3db5c.akpm@linux-foundation.org> <1194024622.6271.108.camel@localhost>
 <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
 <20071103201251.GB26366@elte.hu> <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
 <20071103165525.2dcd55c7@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Arjan van de Ven wrote:

> On Sat, 3 Nov 2007 15:40:48 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> I don't understand how you can call this a "PID namespace design
>> bug", when it clearly has nothing what-so-ever to do with pid
>> namespaces, and everything to do with the *futexes* that blithely
>> assume that pid's are unique and that made it part of the
>> user-visible interface.
>>
>> OF COURSE any pid namespace design will always break such
>> assumptions, but that's not because of any PID namespace bugs. It's
>> what the whole *point* of PID namespaces are. If you use pid's
>> (instead of some opaque cookies), you will not be able to use such
>> things across pid-separation.
>
> well... kind of.
> THere are 2 things around pid namespaces: which pids you can see/touch
> (in proc or signals or otherwise), and the non-uniqueness.
>
> For containers you clearly want the first part... but... is there a
> strong reason to not just *not* create duplicate pids even across
> namespaces? there's no rule in posix or anything similar to fd's afaik
> concerning which pids we can hand out... so we could just make then
> unique globally but just with limited visibility....

two problems that I can think of

1. the container people would like to eventually have the ability to 
migrate containers from one system to another (or to suspend a container) 
in this sort of case trying to fit the allocated PIDs from the container 
into a running system is a problem if PIDs are not allowed to overlap.

2. it seems to me that there is porobably a latent security issue in 
having a global PID namespace with just limited visability. the types of 
bugs that may let you affect a process seem easier to make if the only 
protection is visability rather then complete seperation.

David Lang
