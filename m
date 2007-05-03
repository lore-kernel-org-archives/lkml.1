Return-Path: <linux-kernel-owner+w=401wt.eu-S637778AbXECPs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637778AbXECPs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637777AbXECPs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:48:28 -0400
Received: from gw.ac.upc.es ([147.83.30.3]:48481 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S637778AbXECPs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:48:27 -0400
X-Greylist: delayed 1926 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 11:48:27 EDT
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Transfer-Encoding: 7bit
Message-Id: <16C35E62-A26F-49FC-9CD8-7BADFCD97BA5@ac.upc.edu>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Subject: Per-CPU data as a structure
Date: Thu, 3 May 2007 17:16:17 +0200
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

At the moment, data specific to a CPU is stored in different, fixed- 
size separate arrays by means of the "percpu framework".  I'm working  
on some changes to modify the way some CPUs are represented, and I'm  
wondering what's the rationale behind such a representation.

At first sight, it'd seem more reasonable to have a structure holding  
all the information that is CPU-specific (as is done with any object  
represented within the system).  After searching the mail archives, I  
see that similar changes were proposed before, but those threads did  
not seem to get any reply (so I'm assuming that the changes were not  
desired).

Similarly, and if I understood it correctly, the PDA (Per-processor  
Data Area) also aims to do the above, but at the moment it only  
contains some fields and is not defined in all platforms.  There are  
still a lot of usages of the percpu functionality (such as, e.g., in  
kernel/sched.c).

Part of my changes introduce a new structure that is able to  
represent any kind of CPU (and which each platform can extend to add  
new information to it).  It is supposed to supersede the per-cpu  
definitions.  I bet this could also be redone by using percpu in some  
way...  The thing is I am willing to share my work when I've finished  
it (it is still very much work-in-progress), but first I'm interested  
to know if adding this new structure is a crazy idea (meaning I  
should stick to percpu wherever possible) or something that can be  
accepted later on.

Summarizing, my questions are:
- Why is the code currently using multiple separate arrays (percpu)
   to hold CPU information instead of a structure?
- Could this structure-based approach (instead of all these separate
   arrays) be considered for inclusion into the system?

As far as I can tell, the advantage of percpu is that you can define  
new "fields" anywhere in the code and independently from the rest of  
the system.  Also, I seem to understand that there are performance  
advantages related to this.  But on the other hand, percpu seems like  
an unnatural approach to "reimplement" regular structures.

Thank you very much.

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>


