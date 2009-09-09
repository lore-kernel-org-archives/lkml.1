Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZIIP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZIIP6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZIIP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:58:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZIIP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:58:16 -0400
Message-ID: <4AA7CF1F.3020408@zytor.com>
Date: Wed, 09 Sep 2009 08:51:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Nathan Lynch <ntl@pobox.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v5][PATCH 8/8]: Define clone_with_pids() syscall
References: <20090907211302.GA5892@us.ibm.com> <20090907211700.GH6685@us.ibm.com> <m3zl95l2oz.fsf@pobox.com> <200909091419.50496.arnd@arndb.de>
In-Reply-To: <200909091419.50496.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 05:19 AM, Arnd Bergmann wrote:
> 
> This is a complex problem. The structure above would need a conversion
> for the pointer size that you can avoid by using a u64, but that introduces
> another problem:
> 
> 2. use a single pointer, with variable length data structures:
> 
> struct pid_set {
> 	int num_pids;
> 	pid_t pids[0];
> };
> 
> Since pid_t is always an int, you have no problem with padding or
> incompatible types, but rely on a data structure definition that
> is not in C89 (not sure about C99).
> 

C90 has these data structures, but you have to give the array a nonzero
length:

struct pid_set {
	int num_pids;
	pid_t pids[1];
};

In C99, this is spelt:

struct pid_set {
	int num_pids;
	pid_t pids[];
};

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

