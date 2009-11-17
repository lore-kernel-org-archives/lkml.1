Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZKQVT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZKQVT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZKQVT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:19:28 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62394 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZKQVT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:19:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VsxT0q0g6NTXvtUlRcnSViPBqBDUNMeQyVzeMAU0GOLLYJutHT29wOpUrZOJHrGZx0
         XIbS+7WIQaEcekiiGxf3QPN6tCs+uOyt+whjsc4T6USuijuYGaP6MCTMAarXn3uYOgrB
         63NIhY2BhB2VGqIsY/oypmp4b2yfUIyY6GIFc=
MIME-Version: 1.0
In-Reply-To: <4B0310CD.6050303@redhat.com>
References: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com>
	 <4B0310CD.6050303@redhat.com>
Date: Tue, 17 Nov 2009 23:19:33 +0200
Message-ID: <b64f365b0911171319u122eaf4xdb9da98059f94b85@mail.gmail.com>
Subject: Re: [RFC] Using "page credits" as a solution for common thrashing 
	scenarios
From: Eyal Lotem <eyal.lotem@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The real problematic details are in the data structures.
>
> How to organize the pages in-kernel?
>
> How does the kernel find the pages with the lowest
> score?  In the memory zone where memory needs
> to be freed...
>
> How can the kernel efficiently change the score of
> tens of thousands (or even millions) of pages at once,
> moving them to the right LRU list cheaply?
>
> Making page replacement scale to systems with
> hundreds of gigabytes of memory is a necessity, as
> is evicting the right kind of page (filesystem cache
> vs process page, etc).
>
> Within those constraints, it becomes very hard to
> implement a solution along your ideas.

I agree an implementation that reasonably addresses these concerns is far
from trivial.  I wouldn't give up on finding a way to implement it (or a
good approximation of it) so soon.

Before diving into the exact implementation details, I was wondering if I'm
getting some basic fact wrong -- would this solution (if possible to
implement with reasonable performance) truly mitigate this kind of
thrashing?

Eyal
