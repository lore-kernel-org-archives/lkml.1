Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZHEQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZHEQL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZHEQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:11:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbZHEQLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:11:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=lSXzUFdt03oqr4LrGXcss/NAOUAaln3Qz0FKjs3Cb2h9ifG6vTRmYW5zgoD+kfE1u
	TinTsO9wHaDc9sjNHhZmQ==
MIME-Version: 1.0
In-Reply-To: <20090805102057.GT29252@hawkmoon.kerlabs.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
	 <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com>
	 <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
Date: Wed, 5 Aug 2009 09:11:40 -0700
Message-ID: <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 3:20 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>
> The downside of this is teaching lockdep about this recursive locking. Not that
> simple actually...

Don't we just give each thread's lock its own lock class? That's what
we did for the cgroup hierarchy_mutex.

> so that such cases are currently handled using a higher-level
> lock that prevents races in locking the whole chain (there was one such example
> for locking all vmas with KVM). IIUC, the intent here is to avoid such
> higher-level lock.

cgroup_mutex already fulfills the role of the higher-level lock.

Paul
