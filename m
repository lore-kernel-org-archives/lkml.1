Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZGaVeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZGaVeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZGaVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:34:12 -0400
Received: from are.twiddle.net ([75.149.56.221]:42399 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbZGaVeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:34:11 -0400
X-Greylist: delayed 648 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2009 17:34:11 EDT
Message-ID: <4A7360C3.2060507@twiddle.net>
Date: Fri, 31 Jul 2009 14:23:15 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: use .data.init_task instead of .data.init_thread.
References: <1249073786-29788-1-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1249073786-29788-1-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2009 01:56 PM, Tim Abbott wrote:
> -	/* Note 2 page alignment above.  */
> -	.data.init_thread : {
> -		*(.data.init_thread)
> -	}

NACK.

You can change the section name, sure, but you cannot remove the 2 page 
alignment that we had via the alignment at the end of the init sections. 
  You'll break current_thread_info which is always computed as 
(kernel-stack-pointer & -(2*PAGE_SIZE)).

Similarly it is *not* a bug that the page_aligned sections were before 
data, because we already knew we had 2 page alignment from the end of 
init + 2 pages of init_thread.


r~
