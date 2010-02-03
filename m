Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab0BCQRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:17:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab0BCQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:17:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=NqJWMTIrbqwA:10 a=7U3hwN5JcxgA:10 a=VnNF1IyMAAAA:8 a=jhcOrBV61Ad05xz-tdUA:9 a=bG3HrM_Z8EQ6-FAJGfo9QboJcf4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/3] kernel-shark: fix unitialized handle compile
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <520f0cf11002030805q35029925u36f544f7d37faedb@mail.gmail.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030805q35029925u36f544f7d37faedb@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 11:17:31 -0500
Message-ID: <1265213851.24386.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 17:05 +0100, John Kacur wrote:
> On Mon, Feb 1, 2010 at 5:50 PM, Darren Hart <dvhltc@us.ibm.com> wrote:
> > Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> > ---
> >  kernel-shark.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel-shark.c b/kernel-shark.c
> > index 9dedf48..222381c 100644
> > --- a/kernel-shark.c
> > +++ b/kernel-shark.c
> > @@ -596,10 +596,10 @@ void kernel_shark(int argc, char **argv)
> >                if (ret >= 0)
> >                        input_file = default_input_file;
> >        }
> > -       if (handle)
> > -               handle = tracecmd_open(input_file);
> > +       handle = tracecmd_open(input_file);
> >
> > -       info->handle = handle;
> > +       if (handle)
> > +               info->handle = handle;
> >
> >        /* --- Main window --- */
> >
> > --
> 
> This looks correct, but I'm wondering if it is safe to continue if the
> call to tracecmd_open fails?

Actually this patch is wrong. The real code should be:

-	if (handle)
+	if (input_file)

-- Steve


