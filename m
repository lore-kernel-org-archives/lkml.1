Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZGTRYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZGTRYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZGTRYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:24:00 -0400
Received: from www17.your-server.de ([213.133.104.17]:43188 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZGTRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:23:59 -0400
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer
 dereference
From: Thomas Meyer <thomas@m3y3r.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
In-Reply-To: <4A5A46ED.7010907@gmail.com>
References: <1247410030.1095.1.camel@localhost>
	 <loom.20090712T172408-520@post.gmane.org>  <4A5A46ED.7010907@gmail.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 21:23:54 +0200
Message-Id: <1248117834.7185.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 12.07.2009, 22:26 +0200 schrieb Jiri Slaby:
> On 07/12/2009 07:30 PM, Parag Warudkar wrote:
> > static void selinux_write_opts(struct seq_file *m,
> > 1012                                struct security_mnt_opts *opts)
> > 1013 {
> > 1014         int i;
> > 1015         char *prefix;
> > 1016
> > 1017         for (i = 0; i < opts->num_mnt_opts; i++) {
> > 1018                 char *has_comma;
> > 1019
> > 1020                 if (opts->mnt_opts[i])
> > 1021                         has_comma = strchr(opts->mnt_opts[i], ',');
> >                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> > And that is a NULL pointer dereference - but we just checked for
> > opts->mnt_opts[i] for not NULL. 
> 
> Note, that there is not a NULL dereference. It dereferences 0x40 which
> came in as %rdi. Looks like somebody assigned garbage in there.
> 
> Or a single bit mem error. Is memtest OK with this machine?
Yes it ran fine for one cycle (about 2:15 hours).

Maybe memory in acpi S3 is not so stable? Is this possible?

> 
> What warning tainted the kernel before this oops is still interesting...

