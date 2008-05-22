Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbYEVHHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbYEVHHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYEVHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:07:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:33038 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYEVHHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hLUOgOkvF/ELZUjoJI38IDBEQVB5l9IGcHxhTtb1MVr1PcZhYpIWPc0JXY+jt0+e/6WbIi9MH6Vuo8WcDWaUUjrwMdUvMibhkkZlu00j9RC4Iu5UWJKLlzmtKRJ+9Ot96aL59m0Zhs9X26T4jXwP4tAcrJkhPI+STj2/RNlEvL4=
Message-ID: <863e9df20805220007r36089c93p6f2a787818aa150c@mail.gmail.com>
Date: Thu, 22 May 2008 12:37:20 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Srinivasa D S" <srinivasa@in.ibm.com>,
       "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [RFC] [PATCH] To improve kretprobe scalability
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ananth Mavinakayanahalli" <ananth@in.ibm.com>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>
In-Reply-To: <200805210632.17655.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805210632.17655.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/08, Srinivasa D S <srinivasa@in.ibm.com> wrote:
>  Solution:
>    1) Instead of having one global lock to protect kretprobe instances
>  present in kretprobe object and kretprobe hash table. We will have two locks,
>  one lock for protecting kretprobe hash table and another lock for kretporbe
>  object.

Is it possible to get rid of the kretprobe hash table itself and lose
the kretprobe_lock? It seems like it is just doing a pid-to-instance
mapping. These return instances could be queued in the "current"
task_struct in a LIFO manner. Mutation to this per-task list can be
done with local irqs off...

--
Regards,
Abhishek Sagar
