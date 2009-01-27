Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZA0FRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZA0FRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZA0FRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:17:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbZA0FRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:17:45 -0500
Date: Mon, 26 Jan 2009 21:16:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: lirc@bartelmus.de (Christoph Bartelmus), linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] export get_task_comm()
Message-Id: <20090126211655.c7287768.akpm@linux-foundation.org>
In-Reply-To: <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<AuEeLWHZjFB@christoph>
	<20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 14:09:05 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Hi,
> > 
> > on 19 Jan 09 at 07:36, KOSAKI Motohiro wrote:
> > >> is there any reason why get_task_comm() is not exported in fs/exec.c?
> > 
> > > In general, the only function of anybody necessarity explained is exported.
> > > if you want to export get_task_comm(), you need to explain reasonable
> > > reason.
> > 
> > It's nothing that important: just want to print the executable name to the  
> > logs during error handling. get_task_comm() is the required accessor  
> > function.
> > 
> > http://lirc.cvs.sourceforge.net/viewvc/lirc/lirc/drivers/lirc_dev/lirc_dev.c?revision=1.70&view=markup
> 
> To be honest, I don't use get_task_comm(). but I don't oppose your request.
> 
> ==
> Subject: [PATCH] export get_task_comm()
> 
> task::comm is good debugging information and driver developer want to
> use this information easily.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  fs/exec.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/fs/exec.c
> ===================================================================
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -936,6 +936,7 @@ char *get_task_comm(char *buf, struct ta
>  	task_unlock(tsk);
>  	return buf;
>  }
> +EXPORT_SYMBOL_GPL(get_task_comm);
>  
>  void set_task_comm(struct task_struct *tsk, char *buf)
>  {

Ho hum, I suppose so.  I redid the changelog a bit:

   task_struct.comm[] is useful for debugging and driver developers
   want to use this information easily.  Direct access to
   task_struct.comm[] is a bit racy, so export the official accessor.

