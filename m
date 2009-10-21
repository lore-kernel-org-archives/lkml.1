Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZJUW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZJUW17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZJUW17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:27:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:43843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZJUW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xonlkxq38KQnp9DHtd0AIdAZv/7vhGfjPuu15WHUQ8QuZtVHGc9vHmL7moufdZNd0D
         hPEzkz6oD/NWVyYJbYMj/Gkvh9xR52dyFjrsCHKF3NNzW5pk1FREEUw/PE8Qldc9d0aw
         d3s3O1quNn2AwTZx5ggZoGjwcUmSz4pfENoUQ=
Date: Thu, 22 Oct 2009 00:27:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091021222758.GG4880@nowhere>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de> <20091021213139.GC4880@nowhere> <alpine.LFD.2.00.0910212336290.3526@localhost.localdomain> <20091021215553.GE4880@nowhere> <alpine.LFD.2.00.0910220001470.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910220001470.3526@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 12:06:32AM +0200, John Kacur wrote:
> Okay, I'm sure there is something wrong in this methodology, but it's late 
> at night. At least for a ballpark figure, hopefully it's right.
> 
> Files that mentions "file_operations" - 
> Files that mention "file_operations" and mention "llseek"
> = 1172 - 596 = 572 (in my particular git repo)
> 
> So, over 550 files that need to be set to no_llseek, locked_llseek, or 
> unlocked_llseek. Yikes!
> 
> [jkacur@tycho rt.linux.git]$ git-grep -l file_operations | grep -v 
> Documentation | wc -l
> 1172
> [jkacur@tycho rt.linux.git]$ git-grep -l llseek $(git-grep -l 
> file_operations | grep -v Documentation) | wc -l
> 596
> 


So much?

Ok, a default_lseek pushdown patch wouldn't be accepted :)

Well, I guess we first need to fix the sites that explicitly use the
bkl, one by one, and after that probably propose a new locked version but
without the bkl...

