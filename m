Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZIISfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZIISfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZIISfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:35:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910AbZIISfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:35:13 -0400
Date: Wed, 9 Sep 2009 11:34:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
       Nathan Lynch <ntl@pobox.com>, linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v5][PATCH 8/8]: Define clone_with_pids() syscall
In-Reply-To: <20090909180303.GA21048@us.ibm.com>
Message-ID: <alpine.LFD.2.01.0909091129400.7458@localhost.localdomain>
References: <20090907211302.GA5892@us.ibm.com> <20090907211700.GH6685@us.ibm.com> <m3zl95l2oz.fsf@pobox.com> <200909091419.50496.arnd@arndb.de> <4AA7CF1F.3020408@zytor.com> <20090909180303.GA21048@us.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Sep 2009, Sukadev Bhattiprolu wrote:
> 
> BTW, would it work if we defined 
> 
> 	struct pid_set {
> 		u64 pids;
> 		int num_pids;
> 	}
> 
> where ->pids can be still be a pointer ? The data structure would
> have the same size on all architectures.

I don't think that's all that great. Just go with the C90 version, we 
already have that thing in the kernel, and

	struct pid_set {
		int num_pids;
		pid_t pids[];
	};

looks simple and straightforward. And it even makes your example simpler, 
doesn't it? Ie now it's just

	struct pid_set pids = { 3, { 0, 97, 99 } };

and gcc should do the right thing.

(Of course, in any real case it would be dynamically allocated, but 
whatever).

		Linus
