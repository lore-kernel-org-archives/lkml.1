Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbXIUNrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbXIUNrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbXIUNrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:47:37 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:58088 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757543AbXIUNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:47:36 -0400
Message-ID: <46F3CB76.3080304@moving-picture.com>
Date: Fri, 21 Sep 2007 14:47:34 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arvin Moezzi <moezzia@gmail.com>
CC: linux-kernel@vger.kernel.org, aarapov@redhat.com,
       akpm@linux-foundation.org, hpa@zytor.com
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
References: <E1IXziD-0003YJ-0w@moving-picture.com>	 <3402120c0709201856j58c3775bq8dc7886785a11344@mail.gmail.com>	 <46F39319.9090705@moving-picture.com> <3402120c0709210547mb66162fv759a8f088beb0437@mail.gmail.com>
In-Reply-To: <3402120c0709210547mb66162fv759a8f088beb0437@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arvin Moezzi wrote:

> I think that's not true. 'count' is changing through the iteration.
> The difference in the mem_read():
> 
> * while (count > 0) {
> *     int this_len, retval;
> *
> *      this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
> *      retval = access_process_vm(task, src, page, this_len, 0);
> *
> *      ...
> * }
> 
> is the fact, that this_len = min(PAGE_SIZE, count) is in the
> iteration block, hence retval <= this_len <= count in each iteration
> step. So this is ok. But IMHO in your code 'retval' may be bigger than
> 'count' in the last iteration of the block, because 'max_len' is fix
> through your iteration but 'count' is changing. Or am i missing
> something?

Yes, you are correct ...

Thanks

James Pearson
