Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYJQORo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYJQORo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYJQORh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:17:37 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:49679 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYJQORg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TZ4mqZS2Uy/uU1o+52cXisiNJHNVTvtmFpDtMoWHHq3tI+mi/xYWBXVif2kueGdK8P
         z1g6mLIZiTiDDVUKbhaqjYRODNEcEHSnWqciNO8AVnvN9hh+pFebfaAIBmJD5+Z+ddbM
         unjCHMgUkgNC7XNW74SHZOwlQaFAVoS5L/57o=
Message-ID: <b9df5fa10810170717p36dcb4a9y4e74089069dea03c@mail.gmail.com>
Date: Fri, 17 Oct 2008 20:17:33 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] init: Properly placing noinline keyword.
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081017141354.GA9242@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com>
	 <20081017141354.GA9242@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/08, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Oct 17, 2008 at 07:05:32PM +0600, Rakib Mullick wrote:
>  > Here, noinline keyword should be placed between storage class and type.
>
>
> Why?
Because, scripts/checkpatch.pl warned with following warning:
     ERROR: inline keyword should sit between storage class and type
>
>
>  > --- linux-2.6-stable.orig/init/main.c
>
> > +++ linux-2.6-stable/init/main.c
>
> > @@ -457,7 +457,7 @@ static void __init setup_command_line(ch
>  >   * gcc-3.4 accidentally inlines this function, so use noinline.
>  >   */
>  >
>  > -static void noinline __init_refok rest_init(void)
>  > +static noinline void __init_refok rest_init(void)
>  >       __releases(kernel_lock)
>  >  {
>  >       int pid;
>  > @@ -792,7 +792,7 @@ static void run_init_process(char *init_
>  >  /* This is a non __init function. Force it to be noinline otherwise gcc
>  >   * makes it inline to init() and it becomes part of init.text section
>  >   */
>  > -static int noinline init_post(void)
>  > +static noinline int init_post(void)
>
