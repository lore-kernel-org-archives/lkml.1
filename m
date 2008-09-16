Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYIPPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYIPPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYIPPzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:55:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56597 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYIPPzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:55:19 -0400
Subject: Re: [RFC v5][PATCH 8/8] Dump open file descriptors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 08:54:46 -0700
Message-Id: <1221580486.20360.1.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
> 
> +static int
> +cr_write_fd_ent(struct cr_ctx *ctx, struct files_struct *files, int
> fd)
> +{
> +       struct cr_hdr h;
> +       struct cr_hdr_fd_ent *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +       struct file *file = NULL;
> +       struct fdtable *fdt;
> +       int coe, objref, new, ret;
> +
> +       rcu_read_lock();
> +       fdt = files_fdtable(files);
> +       file = fcheck_files(files, fd);
> +       if (file) {
> +               coe = FD_ISSET(fd, fdt->close_on_exec);
> +               get_file(file);
> +       }
> +       rcu_read_unlock();
> +
> +       /* sanity check (although this shouldn't happen) */
> +       if (!file)
> +               return -EBADF;
> +
> +       new = cr_obj_add_ptr(ctx, (void *) file, &objref, CR_OBJ_FILE, 0);

Dude, you don't need to cast to void*.  

-- Dave

