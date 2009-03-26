Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZCZHxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZCZHxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZCZHwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:52:53 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:19731 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZCZHwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=myW9HUC9Z7QuJbv0bKzkmdq9Ag5J9UQE0vg0Sb1vuGrIyzR7XYdA3ROqoB6k1sA97A
         khlKU57IwmtwqBhe4Q0wbSk6qG05HKerqRAoablnto3x1H60BBA26eunU3VqDDq1yWdZ
         fICDUEEXnu9uvJBejXASyEwCi85+gXXjWYAF4=
Subject: Re: fastboot: unpacking initramfs faster
From: Andreas Robinson <andr345@gmail.com>
To: 7eggert@gmx.de
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <E1LmEqj-0001SN-6Y@be1.7eggert.dyndns.org>
References: <cj9yI-540-17@gated-at.bofh.it>
	 <E1LmEqj-0001SN-6Y@be1.7eggert.dyndns.org>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 08:52:44 +0100
Message-Id: <1238053964.8304.24.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 23:11 +0100, Bodo Eggert wrote:
> Andreas Robinson <andr345@gmail.com> wrote:
> 
> > I tried running the initramfs unpacking asynchronously (and earlier) but
> > ran into a curious problem: The parent thread stalled until
> > decompression was done. I don't know why - I made sure that the two
> > threads ran on different cores. Perhaps the parent was cache starved.
> 
> I could not stall my system by gzip</dev/urandom>/dev/null.
> Maybe you accidentally used vfork?

No, this was an in-kernel test. I used the Arjan's new async facility
which calls kthread_create().

> > I then looked at multithreaded decompression and found that neither gzip
> > files nor deflate streams provide enough information (eg block lengths)
> > to let you share the decompression among threads.
> > 
> > It can be done of course, but obviously not without modifying file
> > formats and userspace tools.
> > 
> > (Thoughts of snowballs and hell presented themselves at this point.)
> 
> Why not make a new set? http://7eggert.dyndns.org:8080/l/bgz.tar.gz

Hmm, well if you think there is a chance of it being accepted, then
sure! I'll cook something up, but will be looking to use LZO first since
it's a bit faster to begin with.

