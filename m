Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZIIELN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZIIELN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbZIIELM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:11:12 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:46030 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIIELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=cs5vziRrv4EgurbkrFTJHs+yc44NyYwqD4vs4XtNm7jedkJBA75HfFJbT0NZ+7CFhJ
         LPxttBuP0ywo1v5yxFhR97y2oorILQ902gCEQZdYhJZ5Mz8B+oOqgyg+4xYiVYAt2BRk
         vnK/QlNicx/IcSKXWVwPC99Is/eFxVHqJYIlc=
Date: Tue, 8 Sep 2009 21:11:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Daniel Walker <dwalker@fifo99.com>,
       Joe Perches <joe@perches.com>, Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch
	init_task.c files.
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com> <1252464546-26394-3-git-send-email-tabbott@ksplice.com> <1252465099.14793.49.camel@desktop> <1252465417.28130.3.camel@Joe-Laptop.home> <1252465625.14793.52.camel@desktop> <1252465802.28130.9.camel@Joe-Laptop.home> <1252466482.14793.60.camel@desktop> <20090909033237.GC23049@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909033237.GC23049@linux-sh.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090909044434.3E30D526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 12:32:38PM +0900, Paul Mundt wrote:
> On Tue, Sep 08, 2009 at 08:21:22PM -0700, Daniel Walker wrote:
> > On Tue, 2009-09-08 at 20:10 -0700, Joe Perches wrote:
> > > On Tue, 2009-09-08 at 20:07 -0700, Daniel Walker wrote:
> > > > On Tue, 2009-09-08 at 20:03 -0700, Joe Perches wrote:
> > > > > On Tue, 2009-09-08 at 19:58 -0700, Daniel Walker wrote:
> > > > > > On Tue, 2009-09-08 at 22:49 -0400, Tim Abbott wrote:
> > > > > > > +union thread_union init_thread_union __init_task_data =
> > > > > > > +       { INIT_THREAD_INFO(init_task) };
> > > > > > All the lines like the above are all producing checkpatch errors.. It
> > > > > > looks like the open brace needs to be up with the equals ..
> > > > > Some checkpatch errors are ignorable.
> > > > > checkpatch output is a guide, not a rule.
> > > > 
> > > > Not errors, those aren't usually ignorable .. Warnings, those could be..
> > > 
> > > Shrug.  So submit a patch...
> > 
> > I would if this was code in the kernel already, but it's not. LKML
> > submission is the process people use to find these types of issues.
> > Issues that should be fixed prior to inclusion, and may have been
> > overlooked..
> > 
> Did you even bother reading the patch? This is exactly the format that is
> in the kernel today (and even predates checkpatch), it's just that
> checkpatch doesn't presently complain about it due to how the section
> parsing is done. If you move the section annotation down to a separate
> line, it also silences checkpatch. In this case, checkpatch is simply
> broken and can be ignored. Stylistic "errors" are complete nonsense.

The

struct data_struct var_name __section_decoration = {
	initializator,
};

is a canonical format for the kernel though so if somebody feels
strongly about being "checkpatch clean" he can post a follow-up
patch ;)

-- 
Dmitry
