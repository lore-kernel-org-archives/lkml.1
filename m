Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbZKODu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbZKODu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 22:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZKODuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 22:50:25 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:57146 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZKODuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 22:50:25 -0500
Date: Sun, 15 Nov 2009 12:50:25 +0900 (JST)
Message-Id: <20091115.125025.80841962.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com, ling.ma@intel.com
Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite,
 bench/mem-memcpy.c
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091113094650.GA1364@elte.hu>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<1258086186-32317-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091113094650.GA1364@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite, bench/mem-memcpy.c
Date: Fri, 13 Nov 2009 10:46:50 +0100

Thanks for your detailed review, Ingo.
I'll fix the points you mentioned, and,

> > +		case 'B':
> > +		case 'b':
> > +			str[i] = '\0';
> > +			break;
> > +		case 'K':
> > +		case 'k':
> > +			if (str[i + 1] != 'B' && str[i + 1] != 'b')
> > +				goto err;
> > +			unit = K;
> > +			str[i] = '\0';
> > +			break;
> > +		case 'M':
> > +		case 'm':
> > +			if (str[i + 1] != 'B' && str[i + 1] != 'b')
> > +				goto err;
> > +			unit = K * K;
> > +			str[i] = '\0';
> > +			break;
> > +		case 'G':
> > +		case 'g':
> > +			if (str[i + 1] != 'B' && str[i + 1] != 'b')
> > +				goto err;
> > +			unit = K * K * K;
> > +			str[i] = '\0';
> > +			break;
> > +		case '\0':	/* only specified figures */
> > +			unit = 1;
> > +			break;
> > +		default:
> > +			if (!isdigit(str[i]))
> > +				goto err;
> > +			break;
> > +		}
> > +	}
> > +
> > +	length = atoi(str) * unit;
> > +	goto end;
> > +
> > +err:
> > +	fprintf(stderr, "Invalid length:%s\n", str);
> > +end:
> > +	free(str);
> > +	return length;
> > +}
> 
> This should go until a utils/*.c helper file i suspect.
> 

before posting patch series mem-memcpy.c related to,
I'll send the patch to add the function that you should go util/.
Because I think this is the independent topic from mem-memcpy.c

Thanks
	Hitoshi

