Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZHCTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZHCTzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZHCTzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:55:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20799 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbZHCTzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:55:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=c46pVEQBDdrBZqLhUxzWAmk/wdlP/1T9TpMGuEb8mGKLmiESqHnCoG/Xgb21o5A56
	j2NTyhTbHbtYvo/sqaVQw==
MIME-Version: 1.0
In-Reply-To: <20090803194555.GA10158@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
	 <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com>
Date: Mon, 3 Aug 2009 12:55:33 -0700
Message-ID: <6599ad830908031255j68ce047x7165bfefa62ed53c@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 12:45 PM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>
> This is probably a stupid idea, but...  what about having zero
> overhead at clone(), and instead, at cgroup_task_migrate(),
> dequeue_task()ing all of the affected threads for the duration of
> the migrate?

That doesn't sound too unreasonable, actually - it would certainly
simplify things a fair bit. Is there a standard API for doing that?
dequeue_task() itself doesn't really look like a public API. I guess
that the task freezer would be one way to accomplish this?

I can imagine that the set of people who'd complain about the latency
hit when migrating with your solution would be smaller than the people
who'd complain about the increased overhead in the normal clone case.

Paul
