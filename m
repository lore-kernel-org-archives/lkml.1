Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXJRVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXJRVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXJRVTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:19:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbXJRVTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:19:05 -0400
Date: Thu, 18 Oct 2007 17:18:57 -0400
From: Rik van Riel <riel@redhat.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
Message-ID: <20071018171857.409255de@bree.surriel.com>
In-Reply-To: <4717CAEC.50203@keyaccess.nl>
References: <20071018202504.GA2854@dmt>
	<4717C43D.6030204@keyaccess.nl>
	<20071018165238.0537eaa6@bree.surriel.com>
	<4717CAEC.50203@keyaccess.nl>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 23:06:52 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> They don't -- that's why I asked if you need both scenario's active
> at the same time. SIGDANGER would just be SIGPLEASEFREEALLYOUCAN with
> the operator deciding through setting the level at which point
> applications get it.
> 
> Or put differently; what's the additional value of notifying an
> application that the system is about to go balistic when you've
> already asked it to free all it could earlier? SIGSEEDAMNITITOLDYOUSO?

The first threshold - "we are about to swap" - means the application
frees memory that it can.  Eg. free()d memory that glibc has not yet
given back to the kernel, or JVM running the garbage collector, or ...

The second threshold - "we are out of memory" - means that the first
approach has failed and the system needs to do something else. On an
embedded system, I would expect some application to exit or maybe
restart itself.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
