Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200Ab0AaABy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0AaABy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797Ab0AaABx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:01:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:52786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0AaABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:01:52 -0500
Date: Sat, 30 Jan 2010 16:02:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100130160242.6532fa81@infradead.org>
In-Reply-To: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 17:45:51 -0600
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> 
> int main ()
> {
> 	int epfd = epoll_create(1);
> 	int i, j;
> 	struct timeval tv;
> 	unsigned long start, end;
> 	const unsigned int count = 60000;
> 
> 	while (1) {
> 		gettimeofday(&tv, NULL);
> 		start = tv.tv_sec * 1000000 + tv.tv_usec;
> 
> 		for (i = 0; i < count; ++i) {
> 			if (epoll_wait(epfd, 0, 1, 1) == -1)
> 				perror("epoll failed");
> 
> 			for (j = 0; j < 10000; ++j)
> 				/* simulate work */;
> 		}
> 		gettimeofday(&tv, NULL);
> 		end = tv.tv_sec * 1000000 + tv.tv_usec;
> 
> 		printf("Iterations Per Sec: %f\n",
> count/((double)(end - start)/1000000)); }
> 
> 	close(epfd);
> }

btw do you have an equivalent program that uses poll instead of epoll
by chance?

