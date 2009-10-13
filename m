Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZJML5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZJML5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZJML5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:57:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:38625 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZJML5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:57:33 -0400
Message-ID: <4AD46977.5020303@openvz.org>
Date: Tue, 13 Oct 2009 15:50:15 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 4/10]: Add target_pid parameter to alloc_pidmap()
References: <20091013044925.GA28181@us.ibm.com> <20091013045104.GD28435@us.ibm.com>
In-Reply-To: <20091013045104.GD28435@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> 
> Subject: [RFC][v8][PATCH 4/10]: Add target_pid parameter to alloc_pidmap()
> 

[ snip ]

> @@ -146,16 +146,22 @@ static int alloc_pidmap_page(struct pidm
>  	return 0;
>  }
>  
> -static int alloc_pidmap(struct pid_namespace *pid_ns)
> +static int alloc_pidmap(struct pid_namespace *pid_ns, int target_pid)

Please no! Better create another function, that will just
atomic_test_and_set() the proper bit in the map. This one
is heavy enough already.

