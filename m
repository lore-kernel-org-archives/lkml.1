Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYIIIHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYIIIHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYIIIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:06:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:27697 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIIIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Iuu2ZnbOKqY9GKzA6n/1qHH5zA89qElHitWY0b+/hpnnuxC4rTIWS9lcTn3R+d+Kme
         AMuwDzZAsKBF9MMrRZd6xGyaKK6VID56fbtYvKGDUhxtvN37cv0sMyxMEZ1ev2EHw3Ut
         tjL78MjHrhRbNJ/2St8H56EoepZ3Ind0q+Fhk=
Message-ID: <19f34abd0809090106r6d7f9e78vd4c201342ad05537@mail.gmail.com>
Date: Tue, 9 Sep 2008 10:06:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Oren Laadan" <orenl@cs.columbia.edu>
Subject: Re: [RFC v4][PATCH 8/9] File descriprtors (dump)
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <1220946154-15174-9-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-9-git-send-email-orenl@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 9:42 AM, Oren Laadan <orenl@cs.columbia.edu> wrote:
> +       fdlist = kmalloc(max * sizeof(*fdlist), GFP_KERNEL);
> +       if (!fdlist)
> +               return -ENOMEM;
> +
> +       spin_lock(&files->file_lock);
> +       fdt = files_fdtable(files);
> +       for (i = 0; i < fdt->max_fds; i++) {
> +               if (!fcheck_files(files, i))
> +                       continue;
> +               if (n == max) {
> +                       /* fcheck_files() is safe with drop/re-acquire
> +                        * of the lock, as it tests:  fd < max_fds */
> +                       spin_unlock(&files->file_lock);
> +                       max *= 2;
> +                       if (max < 0) {  /* overflow ? */
> +                               n = -EMFILE;
> +                               goto out;
> +                       }
> +                       fdlist = krealloc(fdlist, max, GFP_KERNEL);

Hm, shouldn't this be max * sizeof(*fdlist) like the kmalloc above?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
