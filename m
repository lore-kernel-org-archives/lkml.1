Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZAIVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZAIVP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZAIVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:15:14 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZAIVPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:15:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=KmfBr/CYF/ORhHZPiBtgf0rN9qlx8vyK8g8+26LQSLEFv5NXhm4low6cTKQXLdevT
	9uscc3DMzRKJqthWtzOBQ==
MIME-Version: 1.0
In-Reply-To: <4966F230.4020905@cn.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	 <4966EEDD.5070204@cn.fujitsu.com>
	 <6599ad830901082237l664fb403y386482a577ed185e@mail.gmail.com>
	 <4966F230.4020905@cn.fujitsu.com>
Date: Fri, 9 Jan 2009 13:15:09 -0800
Message-ID: <6599ad830901091315y3ddba30cr46a89b2ca965b283@mail.gmail.com>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.19
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 10:44 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> And some other problems, like what's the semantic of /proc/<pid>/cgroup when
> using none subsys.

Since we'd need a way to distinguish between different "no subsys"
hierarchies, we could introduce the idea of a hierarchy name - i.e.
you would mount with options like -onone,name=foo, and this would show
up in /proc/self/cgroup as

name=foo:/path/to/cgroup

You could also name other hierarchies that did have subsystems
mounted, of course. This would allow you to mount existing hierarchies
by name rather than by subsystem set.

Paul
