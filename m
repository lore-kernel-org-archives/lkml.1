Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYE3GsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYE3GsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYE3Grv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:47:51 -0400
Received: from smtp2e.orange.fr ([80.12.242.111]:22050 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYE3Gru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:47:50 -0400
X-ME-UUID: 20080530064748775.BD39B700006D@mwinf2e01.orange.fr
Message-ID: <483FA30F.2050900@cosmosbay.com>
Date: Fri, 30 May 2008 08:47:43 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 26/41] cpu alloc: Convert mib handling to cpu alloc
References: <20080530035620.587204923@sgi.com> <20080530040019.799353964@sgi.com>
In-Reply-To: <20080530040019.799353964@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> Use the cpu alloc functions for the mib handling functions in the net
> layer. The API for snmp_mib_free() is changed to add a size parameter
> since cpu_free() requires a size parameter.
>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  include/net/ip.h     |    2 +-
>  include/net/snmp.h   |   32 ++++++++------------------------
>  net/dccp/proto.c     |    2 +-
>  net/ipv4/af_inet.c   |   31 +++++++++++++++++--------------
>  net/ipv6/addrconf.c  |   11 ++++++-----
>  net/ipv6/af_inet6.c  |   20 +++++++++++---------
>  net/sctp/protocol.c  |    2 +-
>  net/xfrm/xfrm_proc.c |    4 ++--
>  8 files changed, 47 insertions(+), 57 deletions(-)
>   
We also can avoid the use of two arrays when CONFIG_HAVE_CPU_OPS
since _CPU_INC() and __CPU_INC() are both interrupt safe.
This would reduce size of mibs by 50% and complexity (no need to sum)




