Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYCQJ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYCQJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYCQJ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:27:02 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53223 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752020AbYCQJ1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:27:00 -0400
Date: Mon, 17 Mar 2008 04:26:53 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       "Christoph Lameter" <clameter@sgi.com>, "Ken Chen" <kenchen@google.com>,
       Adam Litke <agl@us.ibm.com>
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
Message-Id: <20080317042653.d5a85911.pj@sgi.com>
In-Reply-To: <20080317258.659191058@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> I hacked in also cpuset support. It would be good if 
> Paul double checked that.

Well, from what I can see, Ken Chen wrote the code that deals with
constraints on hugetlb allocation.  So I'll copy him on this reply,
along with the other two subject matter experts I know of in this area,
Christoph Lameter and Adam Litke.

The following is the only cpuset related change I saw in this
patchset.  It looks pretty obvious to me ... just changing the code to
adapt to Andi's new 'struct hstate' for holding what had been global
hugetlb state.

@@ -1228,18 +1252,18 @@ static int hugetlb_acct_memory(long delt
 	 * semantics that cpuset has.
 	 */
 	if (delta > 0) {
-		if (gather_surplus_pages(delta) < 0)
+		if (gather_surplus_pages(h, delta) < 0)
 			goto out;
 
-		if (delta > cpuset_mems_nr(free_huge_pages_node)) {
-			return_unused_surplus_pages(delta);
+		if (delta > cpuset_mems_nr(h->free_huge_pages_node)) {
+			return_unused_surplus_pages(h, delta);
 			goto out;
 		}
 	}
 

Andi claimed, in one of his replies earlier on this thread, that there
were further interactions with cpusets and later patches in the set
that "Add basic support for more than one hstate in hugetlbfs
and partly Add support to have individual hstates for each hugetlbfs
mount", but I'm not understanding what that interaction is yet.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
