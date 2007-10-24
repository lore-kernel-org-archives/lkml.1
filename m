Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbXJXLBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbXJXLBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXJXLAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:00:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:59163 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbXJXLAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=p3FU/i/kojT0CTzwjkUCr9o3taUdx7xXe6CMYFsvtlHQbhyxmZEkPQcO5b3yTydNIz09t1hjVidE7eNhwvFaygXZ8UgQCk+ujQ7lpP5atEQpcXFKhw05S8IpBcKWDUSPCpNw9hZkBotTXcLorcS6JfKJRBPx6xeal5eg9tZqG9s=
Date: Wed, 24 Oct 2007 13:00:43 +0200
To: linux-kernel@vger.kernel.org
Cc: casey@schaufler-ca.com, viro@zeniv.linux.org.uk
Subject: Rule parsing from a virtual FS write() syscall
Message-ID: <20071024110043.GA5297@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In SMACK, some rules are written to a virtual fs file named 
"cipso".

Rule format is

label level[/cat[,cat]]

Under high I/O load we don't recieve the whole rule in one shot.
This means that sometimes the write() operation begins from the 
middle of the rule. Under some conditions, the first rule _letter_
was only recieved while others were recieved in remaining write() 
calls.

Current SMACK versions don't assume fragmented input like above
cases. This means that sometimes bogus rules that does not 
represent users' intent got created.

What is the best way to parse a rule in such hard coditions?

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
