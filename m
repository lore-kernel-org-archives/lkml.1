Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYIZTuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYIZTuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYIZTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:49:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:4772 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYIZTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rudYGyyryALVuoNSwxYPI67q+GOhVcPDmjkFx45xhWJe61YuMj3HWjU8VZXoHuEXwY
         XmJt01By8u5lti5Lt+aBJDHf/qVQCsekIrQ8E0f7/+zwwP08WK5p7loY6hQVFLrzjdYS
         95LpeJrE/1gQ2iYuIs78JjgjB5UluLTz5OfXY=
Date: Fri, 26 Sep 2008 21:50:24 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Corey Minyard <minyard@acm.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, shemminger@vyatta.com
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
Message-ID: <20080926195024.GA2548@ami.dom.local>
References: <20080926031832.GA27289@minyard.local> <20080926040917.GB7209@linux.vnet.ibm.com> <48DCE874.8070704@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DCE874.8070704@acm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 08:49:40AM -0500, Corey Minyard wrote:
...
> I don't believe udp_disconnect() releases the socket.   
> sk_common_release() seems to be the place where the refcount is  
> decremented.  But wherever it is done, it would have to be after the 
> unhash.

...Which, BTW, could be repeated then, so hlist_del_init() matters
yet. (Another sign of such possibility should be this "if ()" in
udp_lib_unhash().)

Jarek P.
