Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZGVU2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZGVU2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZGVU2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:28:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZGVU2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:28:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
Date: Wed, 22 Jul 2009 22:28:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
References: <1247410030.1095.1.camel@localhost> <4A5A46ED.7010907@gmail.com> <1248117834.7185.17.camel@localhost>
In-Reply-To: <1248117834.7185.17.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907222228.18615.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 July 2009, Thomas Meyer wrote:
> Am Sonntag, den 12.07.2009, 22:26 +0200 schrieb Jiri Slaby:
> > On 07/12/2009 07:30 PM, Parag Warudkar wrote:
> > > static void selinux_write_opts(struct seq_file *m,
> > > 1012                                struct security_mnt_opts *opts)
> > > 1013 {
> > > 1014         int i;
> > > 1015         char *prefix;
> > > 1016
> > > 1017         for (i = 0; i < opts->num_mnt_opts; i++) {
> > > 1018                 char *has_comma;
> > > 1019
> > > 1020                 if (opts->mnt_opts[i])
> > > 1021                         has_comma = strchr(opts->mnt_opts[i], ',');
> > >                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> > > And that is a NULL pointer dereference - but we just checked for
> > > opts->mnt_opts[i] for not NULL. 
> > 
> > Note, that there is not a NULL dereference. It dereferences 0x40 which
> > came in as %rdi. Looks like somebody assigned garbage in there.
> > 
> > Or a single bit mem error. Is memtest OK with this machine?
> Yes it ran fine for one cycle (about 2:15 hours).
> 
> Maybe memory in acpi S3 is not so stable? Is this possible?

Generally, it is, but I haven't seen it happen yet.  In theory, if the memory
chips are not refreshed appropriately while suspended, something like this may
happen.

Best,
Rafael
