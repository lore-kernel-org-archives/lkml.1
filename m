Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYILRmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYILRmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYILRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:42:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35866 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYILRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:42:38 -0400
Message-ID: <48CAA9D4.4090000@oracle.com>
Date: Fri, 12 Sep 2008 10:41:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: Re: [RFC/PATCH] dontdiff: generate from gitignore
References: <20080901150951.5cba4dc7@infradead.org> <20080901231419.GA5602@x200.localdomain> <20080912101840.e0b6dd8c.randy.dunlap@oracle.com> <alpine.LFD.1.10.0809121025460.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809121025460.3300@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 12 Sep 2008, Randy Dunlap wrote:
>> Generate the "dontdiff" file from the .gitignore files.
> 
> t's not quite as simple as that, though.
> 
> The .gitignore files are fundamentally location hierarchy-aware, so a 
> ignore entry in one subdirectory only affects that subdirectory 
> (recursively), so if you flatten then, you should take that into account.
> 
> As far as I can tell, your script will generate lots of incorrect entries 
> due to this. Eg, it will generate
> 
> 	parse.[ch]
> 
> as a dontdiff pattern, because scripts/genksyms/.gitignore has that, but 
> that means that now it will ignore parse.c in all the _other_ places, 
> where it *isn't* a generated file (ie mm/parse.c).

Yes, that's one of the reasons that it contains "RFC" in $subject.
There's also no handling of !pattern .gitignore lines....

AFAIK, diff with a dontdiff file does not allow/support full pathname
hierarchies like .gitignore does, so this is probably a futile exercise.  ??

-- 
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
