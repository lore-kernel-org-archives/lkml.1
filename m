Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZFPTOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZFPTOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZFPTO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:14:26 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:47981 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbZFPTOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RW76vBArs+XxdFTtW6PCXJKm/yQCVAb+h42uKfA2jJdDKBi+jhS9AegCbzGbfiSWMY
         8h5yzzRLC4W4aAeix16tLx0zU8EsJAZvfczHutZLrQeYSSJ6mXlalY1oh8IedgXwmyME
         Z5gWYx20GhbNtf8EhmBGLt24ffwtvb82ueQmY=
MIME-Version: 1.0
In-Reply-To: <1245177592.14543.1.camel@wall-e>
References: <1245177592.14543.1.camel@wall-e>
Date: Tue, 16 Jun 2009 21:14:26 +0200
Message-ID: <36ca99e90906161214u6624014q3f3dc4e234bdf772@mail.gmail.com>
Subject: Re: [RFC] set the thread name
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 16, 2009 at 20:39, Stefani Seibold<stefani@seibold.net> wrote:
> Currently it is not easy to identify a thread in linux, because there is
> no thread name like in some other OS.
>
> If there were are thread name then we could extend a kernel segv message
> and the /proc/<pid>/task/<tid>/... entries by a TName value like this:
prctl(PR_SET_NAME, ...) works perfectly here.

Bert

/* -*- c -*- */

#define _GNU_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <pthread.h>
#include <sys/prctl.h>

void *
thread(void *arg)
{
    unsigned long i = (unsigned long)arg;
    char comm[16];
    snprintf(comm, sizeof comm, "task %02lu", i);
    prctl(PR_SET_NAME, comm, 0l, 0l, 0l);

    sleep(10);

    return NULL;
}

int
main(int ac, char *av[])
{
    pthread_t thr;
    unsigned long i, n = 10;
    char comm[16];

    printf("%u\n", getpid());
    sleep(5);
    snprintf(comm, sizeof comm, "master");
    prctl(PR_SET_NAME, comm, 0l, 0l, 0l);
    sleep(5);

    for (i = 0; i < n; i++)
        pthread_create(&thr, NULL, thread, (void *)i);

    pthread_join(thr, NULL);

    return 0;
}

>
> Greetings,
> Stefani
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
