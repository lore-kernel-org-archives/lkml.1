Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYILRiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYILRiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYILRiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:38:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYILRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:38:01 -0400
Date: Fri, 12 Sep 2008 10:36:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: Re: [RFC/PATCH] dontdiff: generate from gitignore
In-Reply-To: <20080912101840.e0b6dd8c.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0809121025460.3300@nehalem.linux-foundation.org>
References: <20080901150951.5cba4dc7@infradead.org> <20080901231419.GA5602@x200.localdomain> <20080912101840.e0b6dd8c.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Sep 2008, Randy Dunlap wrote:
> 
> Generate the "dontdiff" file from the .gitignore files.

t's not quite as simple as that, though.

The .gitignore files are fundamentally location hierarchy-aware, so a 
ignore entry in one subdirectory only affects that subdirectory 
(recursively), so if you flatten then, you should take that into account.

As far as I can tell, your script will generate lots of incorrect entries 
due to this. Eg, it will generate

	parse.[ch]

as a dontdiff pattern, because scripts/genksyms/.gitignore has that, but 
that means that now it will ignore parse.c in all the _other_ places, 
where it *isn't* a generated file (ie mm/parse.c).

		Linus
