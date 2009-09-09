Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZIIR62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZIIR62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZIIR61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:58:27 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53360 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZIIR6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:58:24 -0400
Date: Wed, 9 Sep 2009 11:03:03 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nathan Lynch <ntl@pobox.com>,
       linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v5][PATCH 8/8]: Define clone_with_pids() syscall
Message-ID: <20090909180303.GA21048@us.ibm.com>
References: <20090907211302.GA5892@us.ibm.com> <20090907211700.GH6685@us.ibm.com> <m3zl95l2oz.fsf@pobox.com> <200909091419.50496.arnd@arndb.de> <4AA7CF1F.3020408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA7CF1F.3020408@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
| On 09/09/2009 05:19 AM, Arnd Bergmann wrote:
| > 
| > This is a complex problem. The structure above would need a conversion
| > for the pointer size that you can avoid by using a u64, but that introduces
| > another problem:
| > 
| > 2. use a single pointer, with variable length data structures:
| > 
| > struct pid_set {
| > 	int num_pids;
| > 	pid_t pids[0];
| > };
| > 
| > Since pid_t is always an int, you have no problem with padding or
| > incompatible types, but rely on a data structure definition that
| > is not in C89 (not sure about C99).

C90 or C99 below should work. Is it ok to use a data structure that is
not in C89 ? 

BTW, would it work if we defined 

	struct pid_set {
		u64 pids;
		int num_pids;
	}

where ->pids can be still be a pointer ? The data structure would
have the same size on all architectures.

Thanks for the input

Sukadev
