Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYJ0KZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYJ0KZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYJ0KZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:25:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36508 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbYJ0KZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:25:16 -0400
Subject: Re: [PATCH] gfs2: sparse annotation of gl->gl_spin
From: Steven Whitehouse <swhiteho@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1224873072.5966.7.camel@brick>
References: <1224873072.5966.7.camel@brick>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 27 Oct 2008 10:20:48 +0000
Message-Id: <1225102848.25004.135.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the -nmw GFS2 git tree. Thanks,

Steve.

On Fri, 2008-10-24 at 11:31 -0700, Harvey Harrison wrote:
> fs/gfs2/glock.c:308:5: warning: context problem in 'do_promote': '_spin_unlock' expected different context
> fs/gfs2/glock.c:308:5:    context '*gl+28': wanted >= 1, got 0
> fs/gfs2/glock.c:529:2: warning: context problem in 'do_xmote': '_spin_unlock' expected different context
> fs/gfs2/glock.c:529:2:    context '*gl+28': wanted >= 1, got 0
> fs/gfs2/glock.c:925:3: warning: context problem in 'add_to_queue': '_spin_unlock' expected different context
> fs/gfs2/glock.c:925:3:    context '*gl+28': wanted >= 1, got 0
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/gfs2/glock.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index c962283..27cb9cc 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -293,6 +293,8 @@ static void gfs2_holder_wake(struct gfs2_holder *gh)
>   */
>  
>  static int do_promote(struct gfs2_glock *gl)
> +__releases(&gl->gl_spin)
> +__acquires(&gl->gl_spin)
>  {
>  	const struct gfs2_glock_operations *glops = gl->gl_ops;
>  	struct gfs2_holder *gh, *tmp;
> @@ -511,6 +513,8 @@ static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
>   */
>  
>  static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target)
> +__releases(&gl->gl_spin)
> +__acquires(&gl->gl_spin)
>  {
>  	const struct gfs2_glock_operations *glops = gl->gl_ops;
>  	struct gfs2_sbd *sdp = gl->gl_sbd;
> @@ -576,6 +580,8 @@ static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
>   */
>  
>  static void run_queue(struct gfs2_glock *gl, const int nonblock)
> +__releases(&gl->gl_spin)
> +__acquires(&gl->gl_spin)
>  {
>  	struct gfs2_holder *gh = NULL;
>  
> @@ -877,6 +883,8 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
>   */
>  
>  static inline void add_to_queue(struct gfs2_holder *gh)
> +__releases(&gl->gl_spin)
> +__acquires(&gl->gl_spin)
>  {
>  	struct gfs2_glock *gl = gh->gh_gl;
>  	struct gfs2_sbd *sdp = gl->gl_sbd;

