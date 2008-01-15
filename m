Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYAOMqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYAOMqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYAOMqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:46:35 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:46180 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbYAOMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:46:34 -0500
Message-ID: <478CAB25.30300@grupopie.com>
Date: Tue, 15 Jan 2008 12:46:29 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] mmaped copy too slow?
References: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
> at one point, I found the large file copy speed was different depending on
> the copy method.
> 
> I compared below method
>  - read(2) and write(2).
>  - mmap(2) x2 and memcpy.
>  - mmap(2) and write(2).
> 
> in addition, effect of fadvice(2) and madvice(2) is checked.
> 
> to a strange thing, 
>    - most faster method is read + write + fadvice.
>    - worst method is mmap + memcpy.

One thing you could also try is to pass MAP_POPULATE to mmap so that the 
page tables are filled in at the time of the mmap, avoiding a lot of 
page faults later.

Just my 2 cents,

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
