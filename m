Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZD0Q6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZD0Q6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbZD0Q6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:58:35 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:41750 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756395AbZD0Q6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:58:34 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 27 Apr 2009 17:55:11 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       mark.langsdorf@amd.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [BUG -tip] unable to handle kernel paging request
Message-ID: <20090427165511.GA4801@hades.domain.com>
References: <20090413165913.GA4798@hades.domain.com> <20090413205908.GA15435@linux.vnet.ibm.com> <20090423182417.GA3679@hades.domain.com> <49F57030.3010802@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F57030.3010802@siemens.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:43:28AM +0200, Jan Kiszka wrote:
> > I believe my problem has finally been solved by commit
> > 888d256e9c565cb61505bd218eb37c81fe77a325 in kvm git tree.  Basically, the kvm
> > notifier for the cpufreq was not being unregistered when kvm module was
> > unloaded and, thus, when notifier_call_chain invoked the handler for the kvm,
> > there was a NULL pointer there.
> > 
> > Does this make sense to everybody?
> 
> If your system unloads the kvm modules on shutdown/reboot: yes, would
> make sense.

Yes, I am using kvm modules and these modules are indeed unloaded on shutdown.
So, I believe this is what caused the bug I reported -- Although I initially
though it was related with the powernow-k8 module.

Regards,
--
Luis Henriques
