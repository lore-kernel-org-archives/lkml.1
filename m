Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675Ab0AZFXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab0AZFXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 00:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964Ab0AZFXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 00:23:55 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:40238 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0AZFXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 00:23:54 -0500
Date: Tue, 26 Jan 2010 10:43:41 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
Subject: Re: [PATCH] scripts/kallsyms build warning fix
Message-ID: <20100126051340.GA29802@himanshu-laptop>
References: <1264455681-10578-1-git-send-email-hschauhan@nulltrace.org>
 <2375c9f91001251902p3d632fbdr4c34e43c0973e68f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91001251902p3d632fbdr4c34e43c0973e68f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 11:02:34AM +0800, Américo Wang wrote:
> On Tue, Jan 26, 2010 at 5:41 AM, Himanshu Chauhan
> <hschauhan@nulltrace.org> wrote:
> > Hi all,
> >
> > This is a small patch that fixes the build warning
> > of scripts/kallsyms.c
> >
> > Regards
> > Himanshu
> >
> > Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
> > ---
> >  scripts/kallsyms.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > index 86c3896..e3902fb 100644
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -108,8 +108,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
> >        rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
> >        if (rc != 3) {
> >                if (rc != EOF) {
> > -                       /* skip line */
> > -                       fgets(str, 500, in);
> > +                       /* skip line. sym is used as dummy to
> > +                        * shut of "warn_unused_result" warning.
> > +                        */
> > +                       sym = fgets(str, 500, in);
> >                }
> >                return -1;
> >        }
> 
> Why not use the return value to do some useful checking?

fgets is called as a part of error handling. Its called just to
drop a line and return immediately. read_map is reading the file
in a loop and read_symbol reads line by line. So I think there is
no point in using return value for useful checking. Other checks
like 3 items were returned or !EOF have already been done.

Regards
Himanshu
