Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZFDPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZFDPHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZFDPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:07:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbZFDPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:07:37 -0400
Date: Thu, 4 Jun 2009 08:07:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matt Helsley <matthltc@us.ibm.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
 /proc/*/exe
In-Reply-To: <20090604075532.GU9285@us.ibm.com>
Message-ID: <alpine.LFD.2.01.0906040803410.4880@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
 <20090604075532.GU9285@us.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Matt Helsley wrote:
> 
> Doesn't this pin the vfs mount of the executable for the lifetime of
> the task?

Well, yes, but so does the current code. 

Sure, in _theory_ it can be a non-mmap executable (maybe people still have 
those old OMAGIC a.out executables), and in _theory_ you could unmap the 
executable even if it was originally mmap'ed, but neither of those is 
exactly common, are they?

So in practice, nothing has changed wrt lifetime of the executable.

			Linus
