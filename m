Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZLUX75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZLUX75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZLUX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:59:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:48636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZLUX7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:59:55 -0500
Message-ID: <4B300C97.40409@kernel.org>
Date: Tue, 22 Dec 2009 09:02:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091218222617.384355422@quilx.com> <4B2F2820.5030904@kernel.org> <4B2F2AE8.7060507@kernel.org> <200912220958.16139.rusty@rustcorp.com.au>
In-Reply-To: <200912220958.16139.rusty@rustcorp.com.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 08:28 AM, Rusty Russell wrote:
> On Mon, 21 Dec 2009 06:29:36 pm Tejun Heo wrote:
>> @@ -555,6 +556,7 @@ static void module_unload_free(struct module *mod)
>>  				kfree(use);
>>  				sysfs_remove_link(i->holders_dir, mod->name);
>>  				/* There can be at most one match. */
>> +				free_percpu(i->refptr);
>>  				break;
>>  			}
>>  		}
> 
> This looks very wrong.

Indeed, thanks for spotting it.  Christoph, I'm rolling back all
patches from this series.  Please re-post with updates.

Thanks.

-- 
tejun
