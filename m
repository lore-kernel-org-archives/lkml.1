Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXBFVSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXBFVSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965511AbXBFVSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:18:17 -0500
Received: from mail.macqel.be ([194.78.208.39]:24827 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965508AbXBFVSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:18:16 -0500
Date: Tue, 6 Feb 2007 22:18:14 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Joe Perches <joe@perches.com>, kkeil@suse.de, kai.germaschewski@gmx.de,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206211813.GD2649@ingate.macqel.be>
References: <20070206160446.GE8991@Ahmed> <1170784337.3688.18.camel@localhost> <20070206204130.GU8991@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206204130.GU8991@Ahmed>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:41:30PM +0200, Ahmed S. Darwish wrote:
> On Tue, Feb 06, 2007 at 09:52:17AM -0800, Joe Perches wrote:
> > On Tue, 2007-02-06 at 18:04 +0200, Ahmed S. Darwish wrote:
> > > A patch to use ARRAY_SIZE macro already defined in kernel.h
> > > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> [...]
> > > -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
> > > +    int nelem = ARRAY_SIZE(procfsentries);
> > >      int i;
> > >  
> > >      for (i=0; i < nelem; i++) {
> > 
> > For these patches, perhaps you can eliminate the temporary
> > variable and change the loop to the more common form of
> > 
> > 	for (i = 0; i < ARRAY_SIZE(array); i++) {
> 
> Thanks, I think it's better too. Here's the modified patch.
> 
> A patch to use ARRAY_SIZE macro when appropriate.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
> index d22c022..87fe89c 100644
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -1456,10 +1456,9 @@ static struct procfsentries {
>  
>  static void __init proc_init(void)
>  {
> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>      int i;
>  
> -    for (i=0; i < nelem; i++) {
> +    for (i = 0; i < ARRAY_SIZE(procfsentries); i++) {
>          struct procfsentries *p = procfsentries + i;
>  	p->procent = create_proc_entry(p->name, p->mode, NULL);
>  	if (p->procent) p->procent->read_proc = p->read_proc;
> @@ -1468,10 +1467,9 @@ static void __init proc_init(void)
>  
>  static void __exit proc_exit(void)
>  {
> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>      int i;
>  
> -    for (i=nelem-1; i >= 0; i--) {
> +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {

I would write such decrementing loops as :

       for (i = ARRAY_SIZE(procfsentries); --i >= 0; ) {

Long time ago, that produced better code.  I did not check recently though.

>          struct procfsentries *p = procfsentries + i;
>  	if (p->procent) {
>  	   remove_proc_entry(p->name, NULL);
> diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
> index c4d438c..cff5d1e 100644
> --- a/drivers/isdn/capi/capidrv.c
> +++ b/drivers/isdn/capi/capidrv.c
> @@ -2218,10 +2218,9 @@ static struct procfsentries {
>  
>  static void __init proc_init(void)
>  {
> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>      int i;
>  
> -    for (i=0; i < nelem; i++) {
> +    for (i = 0; i < ARRAY_SIZE(procfsentries); i++) {
>          struct procfsentries *p = procfsentries + i;
>  	p->procent = create_proc_entry(p->name, p->mode, NULL);
>  	if (p->procent) p->procent->read_proc = p->read_proc;
> @@ -2230,10 +2229,9 @@ static void __init proc_init(void)
>  
>  static void __exit proc_exit(void)
>  {
> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>      int i;
>  
> -    for (i=nelem-1; i >= 0; i--) {
> +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {

Same here

>          struct procfsentries *p = procfsentries + i;
>  	if (p->procent) {
>  	   remove_proc_entry(p->name, NULL);
> 
> 
Philippe
