Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYIWWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYIWWBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYIWWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:01:08 -0400
Received: from pih-relay06.plus.net ([212.159.14.19]:56529 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYIWWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:01:07 -0400
Message-ID: <48D96725.1080909@yahoo.com>
Date: Tue, 23 Sep 2008 23:01:09 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com>
In-Reply-To: <48D9460C.5040504@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: fe8dc110d8bc7286782e15a4c8290969
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Ingo when you were asking for the ftrace report I presume that would be 
> for a non preempt kernel (as a preemptive one only showed a very worst 
> latency of 19657 us in one exceptional case)?

With a non preempt kernel I found the logs would simply become too big 
without filtering. On Peter's suggestion I used the following to remove 
the most frequently called functions:

echo acpi_os_release_object > set_ftrace_notrace && echo kmem_cache_* >> 
set_ftrace_notrace && echo acpi_ut_* >> set_ftrace_notrace

By doing counts across multiple runs I would say that the most 
frequently called functions are the following (in most frequently called 
order). The counts are definitely approximate but are reasonable 
relative to each other.

  475325 acpi_os_release_object (acpi_ut_delete_generic_state)
  406895 kmem_cache_free (acpi_os_release_object)
  402838 kmem_cache_alloc (acpi_ut_create_generic_state)
  132968 acpi_ut_update_ref_count (acpi_ut_update_object_reference)
  131041 acpi_ut_pop_generic_state (acpi_ut_update_object_reference)
  131036 acpi_ut_delete_generic_state (acpi_ut_update_object_reference)
  131025 acpi_ut_create_generic_state (acpi_ut_create_update_state)
  131023 acpi_ut_create_update_state_and_push 
(acpi_ut_update_object_reference)
  131020 acpi_ut_create_update_state (acpi_ut_create_update_state_and_push)
  131018 acpi_ut_push_generic_state (acpi_ut_create_update_state_and_push)
   60147 acpi_ns_get_next_node (acpi_ns_delete_namespace_by_owner)
   28974 acpi_ns_get_next_valid_node (acpi_ns_get_next_node)

Logs with the filtering on can be seen here (15Mbytes decompressed each):
http://sucs.org/~sits/test/eeepc-debug/20080923/latency_trace.gz
http://sucs.org/~sits/test/eeepc-debug/20080923/trace.txt.gz

It looks like lots of acpi state is created and deleted...

-- 
Sitsofe | http://sucs.org/~sits/
