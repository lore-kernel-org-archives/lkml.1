Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZCZOOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZCZOOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbZCZOOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:14:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbZCZOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:14:16 -0400
Date: Thu, 26 Mar 2009 15:13:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326141323.GA13048@elte.hu>
References: <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326140312.GB14822@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Then could you grab /proc/fs/jbd2/<dev>:8/history and 
> > /proc/fs/jbd2/<dev>:8/info while running your test workload?

grabbed them after the tests. (not much else ran before and after 
the tests) Here they are:

R/C  tid   wait  run   lock  flush log   hndls  block inlog ctime write drop  close
R    642267 0     5000  0     84    3288  76104  560   562  
R    642268 0     5000  956   2024  5760  68891  491   493  
R    642269 956   7788  8     5104  6696  182270 667   669  
R    642270 8     11800 216   7000  6816  186159 834   837  
R    642271 60    13816 0     0     492   45115  2162  2169 
R    642272 0     5000  0     0     2144  44278  1266  1270 
R    642273 0     5000  0     80    3144  73604  444   446  
R    642274 0     5000  0     276   3120  71741  488   490  
R    642275 0     5000  0     288   3608  87334  526   528  
R    642276 0     5000  0     112   2992  83061  512   514  
R    642277 0     5000  0     84    5892  75029  468   470  
R    642278 0     5976  0     848   8564  71693  483   485  
R    642279 0     9412  340   5432  7104  167415 664   666  
R    642280 340   12536 0     8764  3820  270409 906   909  
R    642281 0     12584 0     0     576   38603  2175  2182 
R    642282 0     5000  0     16    2620  51638  1275  1279 
R    642283 0     5000  0     16    2364  58962  376   378  
R    642284 0     5000  0     56    2812  66644  442   444  
R    642285 0     5000  0     64    2744  61323  479   481  
R    642286 0     5000  0     16    2328  61109  439   441  
R    642287 0     5000  0     40    2752  69227  471   473  
R    642288 0     5000  0     20    2536  60836  454   456  
R    642289 0     5000  0     16    2612  63580  440   442  
R    642290 0     5000  0     48    2528  72629  463   465  
R    642291 0     5000  0     68    2848  75262  498   500  
R    642292 0     5000  0     60    2688  77164  468   470  
R    642293 0     5000  0     0     2188  60922  458   460  
R    642294 0     5000  0     348   3124  79928  528   530  
R    642295 0     5100  0     1896  3128  62695  672   674  
R    642296 0     5024  0     8     4840  17110  90    91   
R    642297 0     5000  0     0     816   14232  1534  1539 
R    642298 0     5000  0     0     2636  52309  2070  2077 
R    642299 0     5000  0     60    2936  67005  375   377  
R    642300 0     5000  0     0     2064  52821  374   376  
R    642301 0     5000  0     228   3344  85321  539   541  
R    642302 0     5000  0     24    5360  54421  458   460  
R    642303 0     5384  52    1388  6548  66593  452   454  
R    642304 52    7936  876   7316  3832  192877 640   642  
R    642305 876   11152 0     5620  3656  262638 821   824  
R    642306 0     9276  0     6172  3768  125379 806   809  
R    642307 0     9920  0     0     6256  11091  702   705  
R    642308 0     5636  0     0     4976  266    119   120  
R    642309 0     5004  0     0     432   11035  1894  1900 
R    642310 0     5000  0     0     2608  43443  1270  1274 
R    642311 0     5000  0     36    2204  55368  333   334  
R    642312 0     5000  0     224   3180  77649  476   478  
R    642313 0     5000  0     20    2496  65989  431   433  
R    642314 0     5000  0     36    2512  71443  466   468  
R    642315 0     5000  956   1796  3916  62650  460   462  
R    642316 956   5712  0     1608  3676  136304 581   583  
R    642317 0     5284  0     1732  3704  123922 572   574  
R    642318 0     5436  0     2032  3652  133710 610   612  
R    642319 0     5684  0     1496  3652  129017 622   624  
R    642320 0     5148  0     640   3304  36529  602   604  
R    642321 0     5004  0     580   5404  23212  216   217  
R    642322 0     5980  0     0     272   4878   149   150  
R    642323 0     5000  0     0     1408  32432  2803  2812 
R    642324 0     5000  0     1184  3416  94751  420   422  
R    642325 0     5000  0     592   3260  94208  502   504  
R    642326 0     5000  0     92    3648  88419  486   488  
R    642327 0     5000  0     80    3052  76222  489   491  
R    642328 0     5000  0     0     4460  60005  429   431  
R    642329 0     5000  1108  2408  6260  77172  426   428  
R    642330 1108  8668  4     4992  3356  166166 622   624  
R    642331 0     8340  0     0     120   75     62    63   
R    642332 0     6984  0     0     68    51     14    15   
R    642333 0     6072  0     0     72    35     14    15   
R    642334 0     6072  0     0     80    31     12    13   
R    642335 0     5732  0     0     84    49     15    16   
R    642336 0     5684  0     0     68    31     12    13   
R    642337 0     5612  0     0     72    36     14    15   
R    642338 0     5636  0     0     68    35     15    16   
R    642339 0     5564  0     0     48    8      3     4    
R    642340 0     6224  0     0     4136  7      8     9    
R    642341 0     5596  0     0     100   11     13    14   
R    642342 0     5660  0     0     156   31     11    12   
R    642343 0     5752  0     0     76    24     12    13   
R    642344 0     5088  0     0     60    12     4     5    
R    642345 0     5032  0     0     40    8      3     4    
R    642346 0     5440  0     0     36    16     4     5    
R    642347 0     8616  0     0     44    13     4     5    
R    642348 0     5284  0     0     44    7      4     5    
R    642349 0     5444  0     0     56    8      4     5    
R    642350 0     5292  0     0     36    8      4     5    
R    642351 0     5140  0     0     44    4      3     4    
R    642352 0     5452  0     0     80    26     7     8    
R    642353 0     11144 0     0     108   5      3     4    
R    642354 0     5692  0     0     36    5      3     4    
R    642355 0     5520  0     0     40    4      3     4    
R    642356 0     5376  0     0     40    5      3     4    
R    642357 0     5228  0     0     44    4      3     4    
R    642358 0     5080  0     0     44    5      3     4    
R    642359 0     17148 0     0     48    6      3     4    
R    642360 0     18148 0     0     44    4      3     4    
R    642361 0     5064  0     0     64    12     4     5    
R    642362 0     5560  0     0     64    33     13    14   
R    642363 0     5228  0     0     36    7      4     5    
R    642364 0     5096  0     0     40    3      3     4    
R    642365 0     8136  0     0     64    19     8     9    
R    642366 0     9140  0     0     64    9      4     5    

312 transaction, each upto 8192 blocks
average: 
  52ms waiting for transaction
  5692ms running transaction
  52ms transaction was being locked
  728ms flushing data (in ordered mode)
  2748ms logging transaction
  51724us average transaction commit time
  61570 handles per transaction
  565 blocks per transaction
  567 logged blocks per transaction

(Hopefully i captured them the right way - should i have done this 
while the test was going on?)

	Ingo
