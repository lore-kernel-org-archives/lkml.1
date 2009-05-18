Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZERLHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZERLHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZERLHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:07:40 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:60453 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZERLHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:07:39 -0400
Date: Mon, 18 May 2009 13:07:38 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, tom.leiming@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel:async function call:introduce
 async_run_inatomic(v2)
Message-ID: <20090518130738.46af51b4@gondolin>
In-Reply-To: <20090517140358.751e12b7@infradead.org>
References: <1242229899-16761-1-git-send-email-tom.leiming@gmail.com>
	<20090513191144.6aae00d7@gondolin>
	<20090514031937.GA5476@nowhere>
	<20090517140358.751e12b7@infradead.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009 14:03:58 -0700,
Arjan van de Ven <arjan@infradead.org> wrote:

> there are some very good reasons to have the option to wait for all;
> module unloading comes to mind for example.

So we would need async_run_synchronize() as something that waits on the
special domain for those cases...

> 
> I'd not like it to automatically punt all async "inatomic" work to a
> separate space; that should be an option for the caller.

I think the idea is only to push the "simple" cases to that domain; a
normal "inatomic" function that allows a domain to be specified should
be added as well.
