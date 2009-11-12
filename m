Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZKLWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZKLWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZKLWD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:03:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53930 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZKLWD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=lf+6jytEDIcpP4n7oWdJ4b0O+UBIkSuuGGEHUIM8NvgB83sr/QVK1yWMXtUvwrzJ8l
         1nGhPHUUStGl2ZNceRZQkbbhf8em6CdfUBCot40jIT6BbiZfy3xOYuoX0/UFzp3Ab6fV
         bF679/iPT7nDogW6EgBDg0rTjehTpbVe5SYiI=
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 12 Nov 2009 20:03:11 -0200
Message-ID: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com>
Subject: perf stat output
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

Some questions about perf stat output. See example:


lucas@LMS-linux:~/programming/testprograms> perf stat -e
L1-dcache-loads -e L1-dcache-load-misses -- make -j
gcc test_schedchanges.c -o test_schedchanges
gcc -pthread test_taskaff1.c -o test_taskaff1
gcc -pthread test_taskaff2.c -o test_taskaff2
gcc -pthread test_taskaff3.c -o test_taskaff3

 Performance counter stats for 'make -j':

       161384667  L1-dcache-loads          #      0.000 M/sec
              24853791  L1-dcache-load-misses    #      0.000 M/sec

	          0.066893389  seconds time elapsed

Why do we have both L1-dcache-loads and  L1-dcache-load-misses with
0.000 M/sec? Also, why do we have 0 M/s when running "perf stat -a -e
cache-misses -e cache-references" but values different than 0 when
running "perf stat -a" without selecting the events?

The last question: what does the  "scaled from X%" mean? Is it related
to the maximum number of performance registers a processor can count
at a time?


Thanks

Lucas De Marchi
