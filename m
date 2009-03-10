Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbZCJRXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbZCJRXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZCJRXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:23:31 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:37940 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZCJRXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:23:30 -0400
Date: Tue, 10 Mar 2009 12:23:20 -0500
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090310122320.313491ce@thinkcentre.lan>
In-Reply-To: <20090310162026.GA9354@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel>
 <20090310105702.43eb1402@thinkcentre.lan> <20090310162026.GA9354@us.ibm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 2B7613FC-0D98-11DE-B904-CBE7E3B37BAC-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> wrote:
> Quoting Nathan Lynch (ntl@pobox.com):
> > Please consider this and a following patch.
> > 
> > >From a0fb96aa41c4d360559013cfd7f32f07f449c1c4 Mon Sep 17 00:00:00 2001
> > From: Nathan Lynch <ntl@pobox.com>
> > Date: Mon, 9 Mar 2009 22:23:02 -0500
> > Subject: [PATCH] checkpoint: make files_deny_checkpointing print task name and pid
> > 
> > This lets the developer know *which* task performed an action that
> > prevents checkpoint.
> > 
> > 
> > Signed-off-by: Nathan Lynch <ntl@pobox.com>
> > ---
> >  fs/file.c                  |    2 +-
> >  fs/open.c                  |    2 +-
> >  include/linux/checkpoint.h |   13 +++++++------
> >  3 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index 0501af6..fcb2803 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -299,7 +299,7 @@ static void __scan_files_for_cr(struct files_struct *files)
> >  			continue;
> >  		if (cr_file_supported(f))
> >  			continue;
> > -		files_deny_checkpointing(files);
> > +		files_deny_checkpointing(current, files);
> 
> Ah but you can't do this, because __scan_files_for_cr is called
> from dupfd which is called during copy_files, right?

Are you saying that the message should identify the child instead of
the parent as the uncheckpointable task?

